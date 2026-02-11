import 'dart:async';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../services/order_service.dart';
import '../mock/tour_mock_data.dart';
import '../../features/orders/models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService;

  // Tour mode reference (will be set after initialization)
  bool Function()? _isTourActive;

  OrderProvider({OrderService? orderService, ApiClient? apiClient})
      : _orderService = orderService ??
            OrderService(apiClient: apiClient ?? ApiClient());

  /// Set tour mode checker (called from tour integration)
  void setTourModeChecker(bool Function() checker) {
    _isTourActive = checker;
  }

  // Pending order (waiting for driver to accept/reject)
  OrderModel? _pendingOrder;
  OrderModel? get pendingOrder => _pendingOrder;

  // Active order (currently being delivered)
  OrderModel? _activeOrder;
  OrderModel? get activeOrder => _activeOrder;

  // Order history
  List<OrderModel> _orderHistory = [];
  List<OrderModel> get orderHistory => List.unmodifiable(
      _orderHistory.where((o) => !TourMockData.isMockOrder(o.id)));

  // Recent completed orders for display (last 3)
  List<OrderModel> get recentOrders => completedOrders.take(3).toList();

  // Active orders (ACCEPTED, ON_THE_WAY, DELIVERED status)
  List<OrderModel> get activeOrders => _orderHistory
      .where((order) =>
          !TourMockData.isMockOrder(order.id) &&
          (order.status == OrderStatus.accepted ||
          order.status == OrderStatus.onTheWay ||
          order.status == OrderStatus.delivered))
      .toList();

  // Completed orders (COMPLETED, CANCELLED status) for history
  List<OrderModel> get completedOrders => _orderHistory
      .where((order) =>
          !TourMockData.isMockOrder(order.id) &&
          (order.status == OrderStatus.completed ||
          order.status == OrderStatus.cancelled))
      .toList();

  // Polling
  Timer? _pollingTimer;
  static const _pollingInterval = Duration(seconds: 15);

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Statistics (fetched from profile, but stored here for display)
  int _totalOrders = 0;
  double _totalEarnings = 0.0;
  int get totalOrders => _totalOrders;
  double get totalEarnings => _totalEarnings;

  // Callback for new order notification (for animations/sounds)
  VoidCallback? onNewOrderReceived;

  /// Start polling for orders when driver goes online
  void startPolling() {
    _stopPolling();
    _pollingTimer = Timer.periodic(_pollingInterval, (_) => _fetchSuggestedOrders());
    // Fetch immediately
    _fetchSuggestedOrders();
  }

  /// Stop polling when driver goes offline
  void stopPolling() {
    _stopPolling();
    _pendingOrder = null;
    notifyListeners();
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Fetch suggested orders from API
  Future<void> _fetchSuggestedOrders() async {
    debugPrint('[OrderProvider] === FETCH SUGGESTED ORDERS ===');
    debugPrint('[OrderProvider] pendingOrder: ${_pendingOrder?.id}');
    debugPrint('[OrderProvider] activeOrder: ${_activeOrder?.id}');

    // Don't fetch if we already have a pending or active order
    if (_pendingOrder != null || _activeOrder != null) {
      debugPrint('[OrderProvider] Skipping fetch - already have pending/active order');
      return;
    }

    try {
      debugPrint('[OrderProvider] Calling orderService.getSuggestedOrders()...');
      final orders = await _orderService.getSuggestedOrders();
      debugPrint('[OrderProvider] Received ${orders.length} suggested orders');

      if (orders.isNotEmpty) {
        _pendingOrder = orders.first;
        debugPrint('[OrderProvider] Set pendingOrder: ${_pendingOrder?.id}');
        debugPrint('[OrderProvider] Order details:');
        debugPrint('[OrderProvider]   status: ${_pendingOrder?.status}');
        debugPrint('[OrderProvider]   restaurant: ${_pendingOrder?.restaurantName}');
        debugPrint('[OrderProvider]   customer: ${_pendingOrder?.customerName}');
        debugPrint('[OrderProvider]   items: ${_pendingOrder?.items.length}');
        debugPrint('[OrderProvider]   pickup: ${_pendingOrder?.pickupAddress}');
        debugPrint('[OrderProvider]   dropoff: ${_pendingOrder?.dropoffAddress}');
        debugPrint('[OrderProvider]   total: ${_pendingOrder?.total}');

        // Notify about new order (haptic handled in UI callback)
        onNewOrderReceived?.call();

        notifyListeners();
      } else {
        debugPrint('[OrderProvider] No suggested orders available');
      }
    } catch (e, stackTrace) {
      debugPrint('[OrderProvider] Error fetching suggested orders: $e');
      debugPrint('[OrderProvider] Stack trace: $stackTrace');
    }
  }

  /// Accept pending order
  Future<bool> acceptOrder() async {
    if (_pendingOrder == null) return false;

    // Tour mode: Simulate acceptance without API call
    // Do NOT inflate real stats — mock orders are for demonstration only
    if (_isTourActive?.call() == true && TourMockData.isMockOrder(_pendingOrder!.id)) {
      _activeOrder = _pendingOrder!.copyWith(
        status: OrderStatus.accepted,
        acceptedAt: DateTime.now(),
      );

      _pendingOrder = null;
      notifyListeners();
      return true;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _orderService.acceptOrder(_pendingOrder!.id);

      // Use pending order data and update status locally
      _activeOrder = _pendingOrder!.copyWith(
        status: OrderStatus.accepted,
        acceptedAt: DateTime.now(),
      );

      // Note: Stats are updated when order is COMPLETED, not accepted
      // This ensures only finished deliveries count towards earnings

      _pendingOrder = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;

      // If order was taken by someone else or suggestion expired, clear pending
      if (e.toString().contains('already taken') ||
          e.toString().contains('409') ||
          e.toString().contains('suggestion expired') ||
          e.toString().contains('403')) {
        _pendingOrder = null;
      }

      notifyListeners();
      return false;
    }
  }

  /// Reject/skip pending order
  Future<void> rejectOrder() async {
    if (_pendingOrder == null) return;

    final orderId = _pendingOrder!.id;

    _pendingOrder = null;
    notifyListeners();

    try {
      await _orderService.rejectOrder(orderId);
    } catch (e) {
      debugPrint('Error rejecting order: $e');
    }
  }

  /// Update order status: ACCEPTED -> ON_THE_WAY
  Future<bool> startDelivery() async {
    if (_activeOrder == null) return false;
    if (_activeOrder!.status == OrderStatus.onTheWay) return true;

    // Tour mode: Simulate status update without API call
    if (_isTourActive?.call() == true && TourMockData.isMockOrder(_activeOrder!.id)) {
      _activeOrder = _activeOrder!.copyWith(status: OrderStatus.onTheWay);
      notifyListeners();
      return true;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final newStatus = await _orderService.updateOrderStatus(
        _activeOrder!.id,
        OrderStatus.onTheWay,
      );
      _activeOrder = _activeOrder!.copyWith(status: newStatus);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update order status: ON_THE_WAY -> DELIVERED
  Future<bool> markDelivered() async {
    if (_activeOrder == null) return false;
    if (_activeOrder!.status == OrderStatus.delivered) return true;

    // Tour mode: Simulate status update without API call
    if (_isTourActive?.call() == true && TourMockData.isMockOrder(_activeOrder!.id)) {
      _activeOrder = _activeOrder!.copyWith(status: OrderStatus.delivered);
      notifyListeners();
      return true;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final newStatus = await _orderService.updateOrderStatus(
        _activeOrder!.id,
        OrderStatus.delivered,
      );
      _activeOrder = _activeOrder!.copyWith(status: newStatus);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // If backend says order is already past DELIVERED, sync local state
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('cannot update status from delivered') ||
          errorMsg.contains('invalid status transition from delivered to delivered')) {
        _activeOrder = _activeOrder!.copyWith(status: OrderStatus.delivered);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update order status: DELIVERED -> COMPLETED
  Future<bool> completeOrder() async {
    if (_activeOrder == null) return false;
    if (_activeOrder!.status == OrderStatus.completed) return true;

    // Tour mode: Simulate status update without API call
    // Do NOT add mock orders to history — they are cleaned up by clearMockOrder()
    if (_isTourActive?.call() == true && TourMockData.isMockOrder(_activeOrder!.id)) {
      _activeOrder = _activeOrder!.copyWith(
        status: OrderStatus.completed,
        completedAt: DateTime.now(),
      );

      _activeOrder = null;
      notifyListeners();
      return true;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final newStatus = await _orderService.updateOrderStatus(
        _activeOrder!.id,
        OrderStatus.completed,
      );

      // Update local order with completed status
      final completedOrder = _activeOrder!.copyWith(
        status: newStatus,
        completedAt: DateTime.now(),
      );

      // Remove any existing entry with the same ID to avoid duplicates
      _orderHistory.removeWhere((o) => o.id == completedOrder.id);
      // Add to history
      _orderHistory.insert(0, completedOrder);

      // Update stats when order is COMPLETED (not accepted)
      _totalOrders++;
      _totalEarnings += completedOrder.deliveryFee + completedOrder.tip;

      _activeOrder = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // If the backend says the order is already completed, clean up local state
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('cannot update status from completed') ||
          errorMsg.contains('already completed')) {
        final completedOrder = _activeOrder!.copyWith(
          status: OrderStatus.completed,
          completedAt: DateTime.now(),
        );
        // Remove any existing entry with the same ID to avoid duplicates
        _orderHistory.removeWhere((o) => o.id == completedOrder.id);
        _orderHistory.insert(0, completedOrder);

        // Update stats for completed order
        _totalOrders++;
        _totalEarnings += completedOrder.deliveryFee + completedOrder.tip;

        _activeOrder = null;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Fetch order history from /api/orders/ endpoint
  /// This returns all orders for the driver and we categorize them locally
  /// Only shows loading indicator on the first fetch (when history is empty).
  /// Subsequent refreshes update data silently to avoid UI flicker.
  Future<void> fetchOrderHistory() async {
    final isFirstLoad = _orderHistory.isEmpty;
    if (isFirstLoad) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      _orderHistory = await _orderService.getOrderHistory();

      // Check if there's an active order in the response
      final activeStatuses = [
        OrderStatus.accepted,
        OrderStatus.onTheWay,
        OrderStatus.delivered,
      ];

      for (final order in _orderHistory) {
        if (activeStatuses.contains(order.status)) {
          // Set as active order if we don't have one
          if (_activeOrder == null) {
            _activeOrder = order;
            debugPrint('[OrderProvider] Found active order from history: ${order.id} - ${order.status}');
          }
          break;
        }
      }

      if (isFirstLoad) _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      if (isFirstLoad) _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch full order details from /orders/{id}/ endpoint
  Future<OrderModel?> fetchOrderDetails(String orderId) async {
    try {
      final order = await _orderService.getOrderDetails(orderId);

      // Update cached data with the fresh details
      if (_activeOrder?.id == orderId) {
        _activeOrder = order;
      } else if (_pendingOrder?.id == orderId) {
        _pendingOrder = order;
      }

      // Update in history list too
      final historyIndex = _orderHistory.indexWhere((o) => o.id == orderId);
      if (historyIndex >= 0) {
        _orderHistory[historyIndex] = order;
      }

      notifyListeners();
      return order;
    } catch (e) {
      debugPrint('[OrderProvider] Error fetching order details: $e');
      return null;
    }
  }

  /// Check for active order on app start
  Future<void> checkActiveOrder() async {
    try {
      final active = await _orderService.getActiveOrder();
      if (active != null) {
        _activeOrder = active;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error checking active order: $e');
    }
  }

  /// Get current delivery step (0-3) for UI
  int get deliveryStep {
    if (_activeOrder == null) return 0;
    switch (_activeOrder!.status) {
      case OrderStatus.accepted:
        return 0; // Heading to pickup
      case OrderStatus.onTheWay:
        return 1; // On the way to customer
      case OrderStatus.delivered:
        return 2; // Arrived, confirming delivery
      case OrderStatus.completed:
        return 3; // Done
      default:
        return 0;
    }
  }

  /// Get next action label for button
  String get nextActionLabel {
    if (_activeOrder == null) return '';
    switch (_activeOrder!.status) {
      case OrderStatus.accepted:
        return 'Start Delivery';
      case OrderStatus.onTheWay:
        return 'Arrived';
      case OrderStatus.delivered:
        return 'Complete';
      default:
        return '';
    }
  }

  /// Execute next action based on current status
  Future<bool> executeNextAction() async {
    if (_activeOrder == null) return false;

    switch (_activeOrder!.status) {
      case OrderStatus.accepted:
        return startDelivery();
      case OrderStatus.onTheWay:
        return markDelivered();
      case OrderStatus.delivered:
        return completeOrder();
      default:
        return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void setStats(int orders, double earnings) {
    // Only set stats from completed orders (from profile)
    // Active orders are not counted until they are completed
    _totalOrders = orders;
    _totalEarnings = earnings;
    notifyListeners();
  }

  /// Get all COMPLETED orders for earnings calculation
  /// Excludes mock tour orders so they never affect real earnings
  /// Only returns completed orders - active orders are not counted
  List<OrderModel> get allOrdersForEarnings {
    return completedOrders
        .where((o) => o.status == OrderStatus.completed)
        .toList();
  }

  // ========== Tour Mode Methods ==========

  /// Inject mock order for tour demonstration.
  /// Mock orders persist until the tour coordinator explicitly clears or accepts them.
  void injectMockOrder(OrderModel mockOrder) {
    _pendingOrder = mockOrder;
    onNewOrderReceived?.call();
    notifyListeners();
  }

  /// Inject a mock order directly as an active order (skips pending).
  /// Used by the tour coordinator so the Orders screen shows an active order.
  void injectMockActiveOrder(OrderModel mockOrder) {
    _activeOrder = mockOrder.copyWith(
      status: OrderStatus.accepted,
      acceptedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Clear mock order from tour
  void clearMockOrder() {
    bool changed = false;

    if (_pendingOrder != null && TourMockData.isMockOrder(_pendingOrder!.id)) {
      _pendingOrder = null;
      changed = true;
    }
    if (_activeOrder != null && TourMockData.isMockOrder(_activeOrder!.id)) {
      _activeOrder = null;
      changed = true;
    }

    // Remove any mock orders that ended up in history (e.g. via completeOrder)
    final beforeLen = _orderHistory.length;
    _orderHistory.removeWhere((o) => TourMockData.isMockOrder(o.id));
    if (_orderHistory.length != beforeLen) {
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }
}
