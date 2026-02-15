import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/providers/tour_provider.dart';
import '../../../core/services/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../tour/tour_keys.dart';
import '../models/order_model.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderModel? _order;
  bool _isLoading = true;
  bool _isUpdating = false;
  String? _error;

  // Tour keys
  final _tourKeys = TourKeys.instance;

  // Location tracking for driver distance
  final LocationService _locationService = LocationService();
  Position? _driverPosition;
  double? _distanceToTarget;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _loadOrder();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _locationService.stopLocationUpdates();
    super.dispose();
  }

  void _startLocationTracking() {
    // Start tracking driver location for active orders
    _locationService.startLocationUpdates(
      onLocationUpdate: (position) {
        if (mounted) {
          setState(() {
            _driverPosition = position;
            _updateDistanceToTarget();
          });
        }
      },
      onError: (error) {
        debugPrint('[OrderDetail] Location error: $error');
      },
    );

    // Also get initial location
    _getInitialLocation();
  }

  Future<void> _getInitialLocation() async {
    setState(() => _isLoadingLocation = true);
    final result = await _locationService.getCurrentLocation();
    if (mounted && result.success && result.position != null) {
      setState(() {
        _driverPosition = result.position;
        _isLoadingLocation = false;
        _updateDistanceToTarget();
      });
    } else {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _updateDistanceToTarget() {
    if (_driverPosition == null || _order == null) return;

    double? targetLat;
    double? targetLng;

    // Determine target based on order status
    final status = _order!.status;

    // For pending/accepted orders - show distance to pickup
    if (status == OrderStatus.pending ||
        status == OrderStatus.searchingForDriver ||
        status == OrderStatus.driverNotificationSent ||
        status == OrderStatus.accepted) {
      targetLat = _order!.pickupLat;
      targetLng = _order!.pickupLng;
    }
    // For on the way/delivered orders - show distance to dropoff
    else if (status == OrderStatus.onTheWay ||
        status == OrderStatus.delivered) {
      targetLat = _order!.dropoffLat;
      targetLng = _order!.dropoffLng;
    }

    if (targetLat != null && targetLng != null) {
      _distanceToTarget = _calculateHaversineDistance(
        _driverPosition!.latitude,
        _driverPosition!.longitude,
        targetLat,
        targetLng,
      );
    }
  }

  /// Calculate distance between two coordinates using Haversine formula
  double _calculateHaversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    final double lat1Rad = _degreesToRadians(lat1);
    final double lat2Rad = _degreesToRadians(lat2);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  void _loadOrder() {
    final orderProvider = context.read<OrderProvider>();

    // Use cached data immediately if available (active/pending/history)
    OrderModel? cached;
    if (orderProvider.activeOrder?.id == widget.orderId) {
      cached = orderProvider.activeOrder;
    } else if (orderProvider.pendingOrder?.id == widget.orderId) {
      cached = orderProvider.pendingOrder;
    } else {
      cached = orderProvider.orderHistory
          .where((o) => o.id == widget.orderId)
          .firstOrNull;
    }

    if (cached != null) {
      setState(() {
        _order = cached;
        _isLoading = false;
      });
    }

    // Always try to refresh from the order details API for complete data
    _fetchOrderDetailsFromAPI(orderProvider, hasCachedData: cached != null);
  }

  Future<void> _fetchOrderDetailsFromAPI(
    OrderProvider orderProvider, {
    bool hasCachedData = false,
  }) async {
    try {
      final order = await orderProvider.fetchOrderDetails(widget.orderId);
      if (mounted && order != null) {
        setState(() {
          _order = order;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[OrderDetail] Failed to fetch order details: $e');
      // Only show error if we have no cached data to display
      if (mounted && !hasCachedData) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  Future<void> _openInGoogleMaps({
    required double lat,
    required double lng,
  }) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _updateOrderStatus(OrderStatus newStatus) async {
    if (_isUpdating || _order == null) return;

    setState(() => _isUpdating = true);

    final orderProvider = context.read<OrderProvider>();
    bool success = false;

    switch (newStatus) {
      case OrderStatus.onTheWay:
        success = await orderProvider.startDelivery();
        break;
      case OrderStatus.delivered:
        success = await orderProvider.markDelivered();
        break;
      case OrderStatus.completed:
        success = await orderProvider.completeOrder();
        break;
      default:
        break;
    }

    if (mounted) {
      setState(() {
        _isUpdating = false;
        if (success) {
          // For completed orders, activeOrder becomes null
          if (newStatus == OrderStatus.completed) {
            _order = _order!.copyWith(status: OrderStatus.completed);
          } else {
            _order =
                orderProvider.activeOrder ??
                _order!.copyWith(status: newStatus);
          }
        }
      });

      if (success) {
        if (newStatus == OrderStatus.completed) {
          context.pop();
        }
      } else {
        // Show error message
        final l10n = AppLocalizations.of(context)!;
        final error = orderProvider.error ?? l10n.failedToUpdateStatus;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _acceptOrder() async {
    if (_isUpdating || _order == null) return;

    setState(() => _isUpdating = true);

    final orderProvider = context.read<OrderProvider>();
    final success = await orderProvider.acceptOrder();

    if (mounted) {
      setState(() {
        _isUpdating = false;
        if (success) {
          _order =
              orderProvider.activeOrder ??
              _order!.copyWith(status: OrderStatus.accepted);
        }
      });

      if (!success) {
        // Show error message
        final l10n = AppLocalizations.of(context)!;
        final error = orderProvider.error ?? l10n.failedToUpdateStatus;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final l10n = AppLocalizations.of(context)!;

    // Watch the provider and sync order with latest data
    final orderProvider = context.watch<OrderProvider>();
    OrderModel? currentOrder;
    if (orderProvider.activeOrder?.id == widget.orderId) {
      currentOrder = orderProvider.activeOrder;
    } else if (orderProvider.pendingOrder?.id == widget.orderId) {
      currentOrder = orderProvider.pendingOrder;
    } else {
      currentOrder = orderProvider.orderHistory
          .where((o) => o.id == widget.orderId)
          .firstOrNull;
    }
    // Update local state if provider has newer data
    if (currentOrder != null && currentOrder != _order) {
      _order = currentOrder;
    }

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: _buildAppBar(context, l10n, textColor),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _order == null) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: _buildAppBar(context, l10n, textColor),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 48,
                color: secondaryColor.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                _error ?? l10n.orderNotFound,
                style: TextStyle(color: secondaryColor),
              ),
            ],
          ),
        ),
      );
    }

    final order = _order!;
    final isTourActive = context.watch<TourProvider>().isTourActive;
    final isPending =
        order.status == OrderStatus.pending ||
        order.status == OrderStatus.searchingForDriver ||
        order.status == OrderStatus.driverNotificationSent;
    final isActive =
        order.status == OrderStatus.accepted ||
        order.status == OrderStatus.onTheWay ||
        order.status == OrderStatus.delivered;
    final showBottomBar = isPending || isActive;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: bgColor,
          appBar: _buildAppBar(context, l10n, textColor),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Badge
                _buildStatusBadge(order, l10n),
                const SizedBox(height: 12),

                // Route Card
                Container(
                  key: isTourActive ? _tourKeys.orderDetailRouteCardKey : null,
                  child: _buildRouteCard(
                    order,
                    l10n,
                    textColor,
                    secondaryColor,
                    surfaceColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Customer Info
                _buildCustomerCard(
                  order,
                  l10n,
                  textColor,
                  secondaryColor,
                  surfaceColor,
                ),

                // Order Items (for food orders)
                if (order.items.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildItemsCard(
                    order,
                    l10n,
                    textColor,
                    secondaryColor,
                    surfaceColor,
                  ),
                ],
                const SizedBox(height: 16),

                // Earnings Card
                Container(
                  key: isTourActive
                      ? _tourKeys.orderDetailEarningsCardKey
                      : null,
                  child: _buildEarningsCard(
                    order,
                    l10n,
                    textColor,
                    secondaryColor,
                    surfaceColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Payment Status Section
                _buildPaymentBanner(
                  order,
                  l10n,
                  textColor,
                  secondaryColor,
                  surfaceColor,
                ),
                const SizedBox(height: 16),

                // Order Meta
                _buildMetaCard(
                  order,
                  l10n,
                  textColor,
                  secondaryColor,
                  surfaceColor,
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
          bottomNavigationBar: showBottomBar
              ? Container(
                  key: isTourActive ? _tourKeys.orderDetailBottomBarKey : null,
                  child: _buildBottomBar(
                    context,
                    order,
                    l10n,
                    surfaceColor,
                    isPending,
                  ),
                )
              : null,
        ),
        // Loading overlay
        if (_isUpdating)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: AppColors.primary),
                      const SizedBox(height: 16),
                      Text(
                        l10n.updatingStatus,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppLocalizations l10n,
    Color textColor,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: textColor),
        onPressed: () => context.pop(),
      ),
      title: Text(
        '${l10n.orderDetails} #${widget.orderId}',
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildStatusBadge(OrderModel order, AppLocalizations l10n) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (order.status) {
      case OrderStatus.pending:
      case OrderStatus.searchingForDriver:
      case OrderStatus.driverNotificationSent:
        statusColor = AppColors.warning;
        statusIcon = Icons.access_time;
        statusText = l10n.newOrder;
        break;
      case OrderStatus.completed:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        statusText = l10n.orderCompleted;
        break;
      case OrderStatus.cancelled:
      case OrderStatus.rejected:
        statusColor = AppColors.error;
        statusIcon = Icons.cancel;
        statusText = l10n.orderCancelled;
        break;
      case OrderStatus.onTheWay:
        statusColor = AppColors.primary;
        statusIcon = Icons.local_shipping;
        statusText = l10n.onTheWay;
        break;
      case OrderStatus.accepted:
        statusColor = AppColors.info;
        statusIcon = Icons.check_circle_outline;
        statusText = l10n.orderAccepted;
        break;
      case OrderStatus.delivered:
        statusColor = AppColors.success;
        statusIcon = Icons.location_on;
        statusText = l10n.atDelivery;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBanner(
    OrderModel order,
    AppLocalizations l10n,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
  ) {
    final isPaid = order.isPaid;
    final color = isPaid ? AppColors.success : AppColors.error;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            isPaid ? Icons.check_circle : Icons.payments,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            isPaid ? l10n.orderPaid : l10n.collectCash,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(
    OrderModel order,
    AppLocalizations l10n,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Restaurant name (for food orders)
          if (order.restaurantName != null &&
              order.restaurantName!.isNotEmpty) ...[
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    size: 16,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    order.restaurantName!,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
          ],

          // Pickup
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 55,
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.pickup,
                      style: TextStyle(fontSize: 11, color: secondaryColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.pickupName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    if (order.pickupStreet != null)
                      Text(
                        order.pickupStreet!,
                        style: TextStyle(fontSize: 12, color: textColor),
                      ),
                    Text(
                      order.pickupCity ?? order.pickupAddress,
                      style: TextStyle(fontSize: 12, color: secondaryColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (order.pickupAddress.isNotEmpty &&
                        order.pickupCity != null)
                      Text(
                        order.pickupAddress,
                        style: TextStyle(
                          fontSize: 11,
                          color: secondaryColor.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              // Navigate to pickup
              if (order.pickupLat != null && order.pickupLng != null)
                GestureDetector(
                  onTap: () => _openInGoogleMaps(
                    lat: order.pickupLat!,
                    lng: order.pickupLng!,
                  ),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.directions,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Dropoff
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.2),
                  border: Border.all(color: AppColors.error, width: 2),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dropoff,
                      style: TextStyle(fontSize: 11, color: secondaryColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.customerName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    if (order.dropoffStreet != null)
                      Text(
                        order.dropoffStreet!,
                        style: TextStyle(fontSize: 12, color: textColor),
                      ),
                    Text(
                      order.dropoffCity ?? order.dropoffAddress,
                      style: TextStyle(fontSize: 12, color: secondaryColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (order.dropoffAddress.isNotEmpty &&
                        order.dropoffCity != null)
                      Text(
                        order.dropoffAddress,
                        style: TextStyle(
                          fontSize: 11,
                          color: secondaryColor.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              // Navigate to dropoff
              if (order.dropoffLat != null && order.dropoffLng != null)
                GestureDetector(
                  onTap: () => _openInGoogleMaps(
                    lat: order.dropoffLat!,
                    lng: order.dropoffLng!,
                  ),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.directions,
                      size: 16,
                      color: AppColors.error,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),
          // Distance & Time row - shows pickup to dropoff
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.route, size: 18, color: AppColors.info),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.pickup} → ${l10n.dropoff}',
                        style: TextStyle(fontSize: 11, color: secondaryColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.formattedDistance,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: secondaryColor.withValues(alpha: 0.2),
                ),
                const SizedBox(width: 12),
                Icon(Icons.schedule, size: 18, color: AppColors.warning),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.estimatedTime,
                        style: TextStyle(fontSize: 11, color: secondaryColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '~${order.estimatedMinutes} ${l10n.min}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Driver's current distance to target (show for all non-completed orders)
          if (_distanceToTarget != null &&
              order.status != OrderStatus.completed &&
              order.status != OrderStatus.cancelled &&
              order.status != OrderStatus.rejected) ...[
            const SizedBox(height: 10),
            _buildDriverDistanceWidget(order, l10n, textColor, secondaryColor),
          ],
        ],
      ),
    );
  }

  Widget _buildDriverDistanceWidget(
    OrderModel order,
    AppLocalizations l10n,
    Color textColor,
    Color secondaryColor,
  ) {
    // Pending and accepted orders show distance to pickup
    final isGoingToPickup =
        order.status == OrderStatus.pending ||
        order.status == OrderStatus.searchingForDriver ||
        order.status == OrderStatus.driverNotificationSent ||
        order.status == OrderStatus.accepted;
    final targetLabel = isGoingToPickup ? l10n.pickup : l10n.dropoff;
    final targetIcon = isGoingToPickup ? Icons.store : Icons.person_pin_circle;
    final targetColor = isGoingToPickup ? AppColors.primary : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            targetColor.withValues(alpha: 0.1),
            targetColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: targetColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: targetColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.my_location, size: 16, color: targetColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.yourDistanceTo,
                      style: TextStyle(fontSize: 11, color: secondaryColor),
                    ),
                    const SizedBox(width: 4),
                    Icon(targetIcon, size: 12, color: targetColor),
                    const SizedBox(width: 2),
                    Text(
                      targetLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: targetColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _isLoadingLocation
                      ? '...'
                      : '${_distanceToTarget!.toStringAsFixed(1)} km',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          // Refresh button
          GestureDetector(
            onTap: _isLoadingLocation ? null : _getInitialLocation,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: secondaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isLoadingLocation
                  ? const Padding(
                      padding: EdgeInsets.all(9),
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : Icon(Icons.refresh, size: 16, color: secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsCard(
    OrderModel order,
    AppLocalizations l10n,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 16,
                color: secondaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.itemsOrdered,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Text(
                '${order.items.length} ${l10n.items}',
                style: TextStyle(fontSize: 12, color: secondaryColor),
              ),
            ],
          ),
          const Divider(height: 20),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        if (item.notes != null && item.notes!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              item.notes!,
                              style: TextStyle(
                                fontSize: 11,
                                color: secondaryColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (item.price > 0)
                    Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(
    OrderModel order,
    AppLocalizations l10n,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.person, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.customerName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                if (order.customerPhone != null &&
                    order.customerPhone!.isNotEmpty)
                  Text(
                    order.customerPhone!,
                    style: TextStyle(fontSize: 12, color: secondaryColor),
                  ),
              ],
            ),
          ),
          if (order.customerPhone != null && order.customerPhone!.isNotEmpty)
            GestureDetector(
              onTap: () async {
                final phoneUrl = Uri.parse('tel:${order.customerPhone}');
                await launchUrl(phoneUrl);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.phone,
                  color: AppColors.success,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEarningsCard(
    OrderModel order,
    AppLocalizations l10n,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (order.subtotal > 0) ...[
            _buildEarningRow(
              l10n.subtotal,
              order.formattedSubtotal,
              secondaryColor,
              textColor,
            ),
            const SizedBox(height: 10),
          ],
          _buildEarningRow(
            l10n.deliveryFee,
            order.formattedDeliveryFee,
            secondaryColor,
            textColor,
          ),
          const SizedBox(height: 10),
          _buildEarningRow(
            l10n.tip,
            order.formattedTip,
            secondaryColor,
            textColor,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.total,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              Text(
                order.formattedTotal,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarningRow(
    String label,
    String value,
    Color secondaryColor,
    Color textColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: secondaryColor)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildMetaCard(
    OrderModel order,
    AppLocalizations l10n,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildMetaRow(
            Icons.tag,
            l10n.orderId,
            '#${order.id}',
            secondaryColor,
            textColor,
            onTap: () {
              Clipboard.setData(ClipboardData(text: order.id));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${l10n.orderId} copied'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _buildMetaRow(
            Icons.category,
            l10n.orderType,
            order.orderType.name.toUpperCase(),
            secondaryColor,
            textColor,
          ),
          const SizedBox(height: 10),
          _buildMetaRow(
            Icons.access_time,
            l10n.created,
            _formatDateTime(order.createdAt),
            secondaryColor,
            textColor,
          ),
          if (order.acceptedAt != null) ...[
            const SizedBox(height: 10),
            _buildMetaRow(
              Icons.check_circle_outline,
              l10n.accepted,
              _formatDateTime(order.acceptedAt!),
              secondaryColor,
              textColor,
            ),
          ],
          if (order.completedAt != null) ...[
            const SizedBox(height: 10),
            _buildMetaRow(
              Icons.done_all,
              l10n.completed,
              _formatDateTime(order.completedAt!),
              secondaryColor,
              textColor,
            ),
          ],
          if (order.items.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildMetaRow(
              Icons.shopping_bag_outlined,
              l10n.itemsOrdered,
              '${order.items.length} ${l10n.items}',
              secondaryColor,
              textColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetaRow(
    IconData icon,
    String label,
    String value,
    Color secondaryColor,
    Color textColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 16, color: secondaryColor),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 13, color: secondaryColor)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            Icon(Icons.copy, size: 14, color: secondaryColor),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/${dt.year} $hour:$minute';
  }

  Future<void> _showStatusConfirmation({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onConfirm();
    }
  }

  Widget _buildBottomBar(
    BuildContext context,
    OrderModel order,
    AppLocalizations l10n,
    Color surfaceColor,
    bool isPending,
  ) {
    // Determine which action button to show based on status
    String actionText;
    String confirmTitle;
    String confirmMessage;
    IconData actionIcon;
    OrderStatus? nextStatus;
    Color actionColor = AppColors.primary;
    bool isAcceptAction = false;

    if (isPending) {
      actionText = l10n.orderAccepted;
      confirmTitle = l10n.acceptOrder;
      confirmMessage = l10n.acceptOrderConfirmation;
      actionIcon = Icons.check;
      nextStatus = OrderStatus.accepted;
      actionColor = AppColors.success;
      isAcceptAction = true;
    } else {
      switch (order.status) {
        case OrderStatus.accepted:
          actionText = l10n.onTheWay;
          confirmTitle = l10n.startDelivery;
          confirmMessage = l10n.startDeliveryConfirmation;
          actionIcon = Icons.directions_car;
          nextStatus = OrderStatus.onTheWay;
          break;
        case OrderStatus.onTheWay:
          actionText = l10n.markAsDelivered;
          confirmTitle = l10n.arrivedAtDropoff;
          confirmMessage = l10n.arrivedAtDropoffConfirmation;
          actionIcon = Icons.location_on;
          nextStatus = OrderStatus.delivered;
          break;
        case OrderStatus.delivered:
          actionText = l10n.orderCompleted;
          confirmTitle = l10n.completeOrder;
          confirmMessage = !order.isPaid
              ? '${l10n.collectCashReminder}\n\n${l10n.completeOrderConfirmation}'
              : l10n.completeOrderConfirmation;
          actionIcon = Icons.check_circle;
          nextStatus = OrderStatus.completed;
          actionColor = AppColors.success;
          break;
        default:
          actionText = l10n.navigate;
          confirmTitle = '';
          confirmMessage = '';
          actionIcon = Icons.navigation;
          nextStatus = null;
      }
    }

    // Get target coordinates for navigation
    double? targetLat;
    double? targetLng;
    if (order.status == OrderStatus.accepted) {
      targetLat = order.pickupLat;
      targetLng = order.pickupLng;
    } else {
      targetLat = order.dropoffLat;
      targetLng = order.dropoffLng;
    }

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Navigation buttons row
              if (targetLat != null && targetLng != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      // Navigate button
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: OutlinedButton.icon(
                            onPressed: () => context.push(
                              RouteConstants.navigationPath(order.id),
                            ),
                            icon: const Icon(
                              Icons.navigation_outlined,
                              size: 18,
                            ),
                            label: Text(
                              l10n.navigate,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Google Maps button
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: OutlinedButton.icon(
                            onPressed: () => _openInGoogleMaps(
                              lat: targetLat!,
                              lng: targetLng!,
                            ),
                            icon: const Icon(Icons.map_outlined, size: 18),
                            label: Text(
                              l10n.googleMaps,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.info,
                              side: const BorderSide(color: AppColors.info),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Action button (status update or accept)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isUpdating
                      ? null
                      : () {
                          _showStatusConfirmation(
                            title: confirmTitle,
                            message: confirmMessage,
                            onConfirm: () {
                              if (isAcceptAction) {
                                _acceptOrder();
                              } else if (nextStatus != null) {
                                _updateOrderStatus(nextStatus);
                              }
                            },
                          );
                        },
                  icon: _isUpdating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(actionIcon, size: 20),
                  label: Text(
                    actionText,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: actionColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
