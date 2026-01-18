import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../api/api_client.dart';
import '../services/order_service.dart';
import '../../features/orders/models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService;

  OrderProvider({OrderService? orderService, ApiClient? apiClient})
      : _orderService = orderService ??
            OrderService(apiClient: apiClient ?? ApiClient());

  // Pending order (waiting for driver to accept/reject)
  OrderModel? _pendingOrder;
  OrderModel? get pendingOrder => _pendingOrder;

  // Active order (currently being delivered)
  OrderModel? _activeOrder;
  OrderModel? get activeOrder => _activeOrder;

  // Order history
  List<OrderModel> _orderHistory = [];
  List<OrderModel> get orderHistory => List.unmodifiable(_orderHistory);

  // Recent completed orders for display (last 3)
  List<OrderModel> get recentOrders => completedOrders.take(3).toList();

  // Active orders (ACCEPTED, ON_THE_WAY, DELIVERED status)
  List<OrderModel> get activeOrders => _orderHistory
      .where((order) =>
          order.status == OrderStatus.accepted ||
          order.status == OrderStatus.onTheWay ||
          order.status == OrderStatus.delivered)
      .toList();

  // Completed orders (COMPLETED, CANCELLED status) for history
  List<OrderModel> get completedOrders => _orderHistory
      .where((order) =>
          order.status == OrderStatus.completed ||
          order.status == OrderStatus.cancelled)
      .toList();

  // Polling and timers
  Timer? _pollingTimer;
  Timer? _acceptTimer;
  static const _pollingInterval = Duration(seconds: 15);

  // Accept countdown
  int _acceptCountdown = 0;
  int get acceptCountdown => _acceptCountdown;

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
    _acceptCountdown = 0;
    notifyListeners();
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _acceptTimer?.cancel();
    _acceptTimer = null;
  }

  /// Fetch suggested orders from API
  Future<void> _fetchSuggestedOrders() async {
    // Don't fetch if we already have a pending or active order
    if (_pendingOrder != null || _activeOrder != null) return;

    try {
      final orders = await _orderService.getSuggestedOrders();

      if (orders.isNotEmpty) {
        _pendingOrder = orders.first;

        // Trigger haptic feedback
        HapticFeedback.heavyImpact();

        // Notify about new order
        onNewOrderReceived?.call();

        // Start accept countdown
        _startAcceptCountdown();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching suggested orders: $e');
    }
  }

  void _startAcceptCountdown() {
    _acceptCountdown = 30; // 30 seconds to accept
    _acceptTimer?.cancel();
    _acceptTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_acceptCountdown > 0) {
        _acceptCountdown--;
        notifyListeners();
      } else {
        // Auto-reject if not accepted in time
        rejectOrder();
      }
    });
  }

  /// Accept pending order
  Future<bool> acceptOrder() async {
    if (_pendingOrder == null) return false;

    _acceptTimer?.cancel();
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final acceptedOrder = await _orderService.acceptOrder(_pendingOrder!.id);

      _activeOrder = acceptedOrder.copyWith(
        status: OrderStatus.accepted,
        acceptedAt: DateTime.now(),
      );

      // Add earnings when order is accepted (use deliveryFee as driver earnings)
      _totalOrders++;
      _totalEarnings += acceptedOrder.deliveryFee;

      _pendingOrder = null;
      _acceptCountdown = 0;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;

      // If order was taken by someone else, clear pending
      if (e.toString().contains('already taken') || e.toString().contains('409')) {
        _pendingOrder = null;
        _acceptCountdown = 0;
      }

      notifyListeners();
      return false;
    }
  }

  /// Reject/skip pending order
  Future<void> rejectOrder() async {
    if (_pendingOrder == null) return;

    _acceptTimer?.cancel();
    final orderId = _pendingOrder!.id;

    _pendingOrder = null;
    _acceptCountdown = 0;
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

    _isLoading = true;
    notifyListeners();

    try {
      final updatedOrder = await _orderService.updateOrderStatus(
        _activeOrder!.id,
        OrderStatus.onTheWay,
      );
      _activeOrder = updatedOrder;
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

    _isLoading = true;
    notifyListeners();

    try {
      final updatedOrder = await _orderService.updateOrderStatus(
        _activeOrder!.id,
        OrderStatus.delivered,
      );
      _activeOrder = updatedOrder;
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

  /// Update order status: DELIVERED -> COMPLETED
  Future<bool> completeOrder() async {
    if (_activeOrder == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedOrder = await _orderService.updateOrderStatus(
        _activeOrder!.id,
        OrderStatus.completed,
      );

      // Add to history
      _orderHistory.insert(0, updatedOrder);

      _activeOrder = null;
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

  /// Fetch order history from /api/orders/ endpoint
  /// This returns all orders for the driver and we categorize them locally
  Future<void> fetchOrderHistory() async {
    _isLoading = true;
    notifyListeners();

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

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
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
    // Add active order earnings to profile stats if there's an active order
    if (_activeOrder != null) {
      _totalOrders = orders + 1;
      _totalEarnings = earnings + _activeOrder!.deliveryFee;
    } else {
      _totalOrders = orders;
      _totalEarnings = earnings;
    }
    notifyListeners();
  }

  /// Get all orders including active order for earnings calculation
  List<OrderModel> get allOrdersForEarnings {
    final orders = List<OrderModel>.from(_orderHistory);
    // Add active order if it's not already in history
    if (_activeOrder != null && !orders.any((o) => o.id == _activeOrder!.id)) {
      orders.insert(0, _activeOrder!);
    }
    return orders;
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }
}
