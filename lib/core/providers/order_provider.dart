import 'dart:async';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../services/order_service.dart';
import '../mock/tour_mock_data.dart';
import '../../features/orders/models/order_model.dart';

/// Reason an accept/reject action failed, so the UI can show the right message.
enum OrderActionError {
  alreadyTaken,   // 409 — another driver got it
  expired,        // 403 — suggestion timed out
  notFound,       // 404 — order no longer exists
  network,        // connection / timeout
  unknown,        // anything else
}

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

  // Loading states — _isActionLoading is for accept/reject/status updates only
  bool _isActionLoading = false;
  bool get isLoading => _isActionLoading;

  // Separate flag for background data fetches (never shown to UI)
  bool _isFetchingHistory = false;

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

  /// Fetch suggested orders from API.
  /// Always replaces pending order data with fresh API data.
  Future<void> _fetchSuggestedOrders() async {
    debugPrint('[OrderProvider] === FETCH SUGGESTED ORDERS ===');
    debugPrint('[OrderProvider] pendingOrder: ${_pendingOrder?.id}');
    debugPrint('[OrderProvider] activeOrder: ${_activeOrder?.id}');

    try {
      debugPrint('[OrderProvider] Calling orderService.getSuggestedOrders()...');
      final orders = await _orderService.getSuggestedOrders();
      debugPrint('[OrderProvider] Received ${orders.length} suggested orders');

      if (orders.isNotEmpty) {
        final freshOrder = orders.first;
        final isNewOrder = _pendingOrder == null || _pendingOrder!.id != freshOrder.id;

        // Always update with fresh data
        _pendingOrder = freshOrder;
        debugPrint('[OrderProvider] Set pendingOrder: ${_pendingOrder?.id} (isNew: $isNewOrder)');

        // Only trigger new-order animation/haptic for a genuinely new order
        if (isNewOrder) {
          onNewOrderReceived?.call();
        }

        notifyListeners();
      } else {
        // No suggested orders — clear stale pending order if the server
        // no longer has it (e.g. it was assigned to another driver)
        if (_pendingOrder != null) {
          debugPrint('[OrderProvider] Clearing stale pending order ${_pendingOrder!.id}');
          _pendingOrder = null;
          notifyListeners();
        }
        debugPrint('[OrderProvider] No suggested orders available');
      }
    } catch (e, stackTrace) {
      debugPrint('[OrderProvider] Error fetching suggested orders: $e');
      debugPrint('[OrderProvider] Stack trace: $stackTrace');
    }
  }

  /// Accept pending order.
  /// Returns `null` on success, or an [OrderActionError] on failure.
  Future<OrderActionError?> acceptOrder() async {
    if (_pendingOrder == null) return OrderActionError.notFound;

    // Tour mode: Simulate acceptance without API call
    if (_isTourActive?.call() == true && TourMockData.isMockOrder(_pendingOrder!.id)) {
      _activeOrder = _pendingOrder!.copyWith(
        status: OrderStatus.accepted,
        acceptedAt: DateTime.now(),
      );
      _pendingOrder = null;
      notifyListeners();
      return null;
    }

    _isActionLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _orderService.acceptOrder(_pendingOrder!.id);

      _activeOrder = _pendingOrder!.copyWith(
        status: OrderStatus.accepted,
        acceptedAt: DateTime.now(),
      );
      _pendingOrder = null;
      _isActionLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isActionLoading = false;

      final errorMsg = e.toString().toLowerCase();
      OrderActionError reason;

      if (e is ApiException && e.statusCode == 409 || errorMsg.contains('already taken')) {
        reason = OrderActionError.alreadyTaken;
        _pendingOrder = null;
      } else if (e is ApiException && e.statusCode == 403 || errorMsg.contains('suggestion expired') || errorMsg.contains('expired')) {
        reason = OrderActionError.expired;
        _pendingOrder = null;
      } else if (e is ApiException && e.statusCode == 404 || errorMsg.contains('not found')) {
        reason = OrderActionError.notFound;
        _pendingOrder = null;
      } else if (errorMsg.contains('connection') || errorMsg.contains('timeout') || errorMsg.contains('network')) {
        reason = OrderActionError.network;
        // Keep pending order — the driver can retry
      } else {
        reason = OrderActionError.unknown;
        _pendingOrder = null;
      }

      _error = e.toString();
      notifyListeners();
      return reason;
    }
  }

  /// Reject/skip pending order.
  /// Returns `null` on success, or an [OrderActionError] on failure.
  Future<OrderActionError?> rejectOrder() async {
    if (_pendingOrder == null) return null;

    final orderId = _pendingOrder!.id;

    // Clear immediately for snappy UI
    _pendingOrder = null;
    notifyListeners();

    try {
      await _orderService.rejectOrder(orderId);
      return null;
    } catch (e) {
      debugPrint('[OrderProvider] Error rejecting order: $e');
      // Order is already cleared from UI — just inform the user if it was a real problem
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('connection') || errorMsg.contains('timeout') || errorMsg.contains('network')) {
        return OrderActionError.network;
      }
      // For reject, most errors are harmless (order already gone, etc.)
      return null;
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

    _isActionLoading = true;
    notifyListeners();

    try {
      final newStatus = await _orderService.updateOrderStatus(
        _activeOrder!.id,
        OrderStatus.onTheWay,
      );
      _activeOrder = _activeOrder!.copyWith(status: newStatus);
      _isActionLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isActionLoading = false;
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

    _isActionLoading = true;
    notifyListeners();

    try {
      final newStatus = await _orderService.updateOrderStatus(
        _activeOrder!.id,
        OrderStatus.delivered,
      );
      _activeOrder = _activeOrder!.copyWith(status: newStatus);
      _isActionLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // If backend says order is already past DELIVERED, sync local state
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('cannot update status from delivered') ||
          errorMsg.contains('invalid status transition from delivered to delivered')) {
        _activeOrder = _activeOrder!.copyWith(status: OrderStatus.delivered);
        _isActionLoading = false;
        notifyListeners();
        return true;
      }
      _error = e.toString();
      _isActionLoading = false;
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

    _isActionLoading = true;
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
      _isActionLoading = false;
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
        _isActionLoading = false;
        notifyListeners();
        return true;
      }
      _error = e.toString();
      _isActionLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Fetch order history from /api/orders/ endpoint.
  /// Replaces all cached data with fresh API data on every call.
  /// Never touches _isActionLoading so buttons remain interactive.
  Future<void> fetchOrderHistory() async {
    if (_isFetchingHistory) return;
    _isFetchingHistory = true;

    try {
      final freshOrders = await _orderService.getOrderHistory();

      // Replace entire history with fresh data
      _orderHistory = freshOrders;

      // Sync active order with fresh data from the server
      final activeStatuses = [
        OrderStatus.accepted,
        OrderStatus.onTheWay,
        OrderStatus.delivered,
      ];

      final freshActive = freshOrders.cast<OrderModel?>().firstWhere(
        (o) => activeStatuses.contains(o!.status),
        orElse: () => null,
      );

      if (freshActive != null) {
        // Always update active order with latest server data
        _activeOrder = freshActive;
      } else if (_activeOrder != null) {
        // Server says no active order — clear local stale one
        // unless we just accepted it and the server hasn't caught up
        final serverHasOurOrder = freshOrders.any((o) => o.id == _activeOrder!.id);
        if (serverHasOurOrder) {
          _activeOrder = null;
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('[OrderProvider] Error fetching order history: $e');
    } finally {
      _isFetchingHistory = false;
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

  /// Clear all order data (called on logout)
  void clearAll() {
    _stopPolling();
    _pendingOrder = null;
    _activeOrder = null;
    _orderHistory = [];
    _totalOrders = 0;
    _totalEarnings = 0.0;
    _isActionLoading = false;
    _error = null;
    notifyListeners();
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
