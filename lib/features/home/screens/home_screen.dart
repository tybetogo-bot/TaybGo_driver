import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/driver_provider.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/providers/tour_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/mock/tour_mock_data.dart';
import '../../orders/models/order_model.dart';
import '../../tour/widgets/tour_welcome_card.dart';
import '../../tour/tour_keys.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _showNewOrderAnimation = false;
  bool _isRefreshing = false;
  OrderProvider? _orderProvider;

  // Tour keys from singleton
  final _tourKeys = TourKeys.instance;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _orderProvider = context.read<OrderProvider>();
      final driverProvider = context.read<DriverProvider>();
      final tourProvider = context.read<TourProvider>();

      // Set up tour mode checkers in providers
      _orderProvider!.setTourModeChecker(() => tourProvider.isTourActive);
      driverProvider.setTourModeChecker(() => tourProvider.isTourActive);

      _orderProvider!.onNewOrderReceived = _onNewOrder;

      // Fetch order history for recent orders display
      _orderProvider!.fetchOrderHistory();

      // Check for any active order (in case app was closed during delivery)
      _orderProvider!.checkActiveOrder();

      // Fetch profile and sync stats to order provider
      driverProvider.fetchProfile().then((_) {
        if (!mounted) return;

        // If no profile exists (403), redirect to application form
        if (driverProvider.profileExists == false) {
          context.go(RouteConstants.application);
          return;
        }

        final profile = driverProvider.profile;
        if (profile != null) {
          _orderProvider?.setStats(profile.totalOrders, profile.totalEarnings);

          // If driver is already online, start polling for orders
          if (profile.isOnline) {
            _orderProvider?.startPolling();
          }
        }
      });
    });
  }

  void _onNewOrder() {
    HapticFeedback.heavyImpact();
    setState(() => _showNewOrderAnimation = true);
    _pulseController.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _pulseController.stop();
        _pulseController.reset();
        setState(() => _showNewOrderAnimation = false);
      }
    });
  }

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);

    final driverProvider = context.read<DriverProvider>();

    await Future.wait([
      _orderProvider!.fetchOrderHistory(),
      _orderProvider!.checkActiveOrder(),
      driverProvider.fetchProfile().then((_) {
        final profile = driverProvider.profile;
        if (profile != null) {
          _orderProvider?.setStats(profile.totalOrders, profile.totalEarnings);

          // Ensure polling is running if driver is online
          if (profile.isOnline) {
            _orderProvider?.startPolling();
          }
        }
      }),
    ]);

    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  Future<void> _toggleOnline(DriverProvider driverProvider, OrderProvider orderProvider) async {
    final result = await driverProvider.toggleOnline();

    if (!mounted) return;

    switch (result) {
      case ToggleOnlineResult.success:
        if (driverProvider.isOnline) {
          orderProvider.startPolling();
        } else {
          orderProvider.stopPolling();
        }
        break;

      case ToggleOnlineResult.accountNotVerified:
        _showAccountNotVerifiedDialog();
        break;

      case ToggleOnlineResult.locationDenied:
        final l10n = AppLocalizations.of(context)!;
        _showLocationPermissionDialog(
          title: l10n.locationRequired,
          message: l10n.enableLocationAccess,
          actionLabel: l10n.enable,
          onAction: () => _toggleOnline(driverProvider, orderProvider),
        );
        break;

      case ToggleOnlineResult.locationDeniedForever:
        final l10n = AppLocalizations.of(context)!;
        _showLocationPermissionDialog(
          title: l10n.locationPermissionDenied,
          message: l10n.pleaseEnableLocationInSettings,
          actionLabel: l10n.settings,
          onAction: () => driverProvider.openAppSettings(),
        );
        break;

      case ToggleOnlineResult.locationServiceDisabled:
        final l10n = AppLocalizations.of(context)!;
        _showLocationPermissionDialog(
          title: l10n.gpsDisabled,
          message: l10n.pleaseEnableGps,
          actionLabel: l10n.enable,
          onAction: () => driverProvider.openLocationSettings(),
        );
        break;

      case ToggleOnlineResult.apiError:
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(driverProvider.error ?? l10n.failedToUpdateStatus),
            backgroundColor: AppColors.error,
          ),
        );
        break;
    }
  }

  void _showAccountNotVerifiedDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(l10n.accountUnderReview),
        content: Text(l10n.accountBeingVerified),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showLocationPermissionDialog({
    required String title,
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onAction();
            },
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }

  void _startTour(TourProvider tourProvider) async {
    // Start the tour
    await tourProvider.startTour();

    // The tour coordinator will handle the rest
    // For now, we'll inject a mock order after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && tourProvider.isTourActive) {
        final mockOrder = TourMockData.createMockOrder();
        _orderProvider?.injectMockOrder(mockOrder);
      }
    });
  }

  @override
  void dispose() {
    _orderProvider?.onNewOrderReceived = null;
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final l10n = AppLocalizations.of(context)!;

    return Consumer2<OrderProvider, DriverProvider>(
      builder: (context, orderProvider, driverProvider, _) {
        final isOnline = driverProvider.isOnline;
        final profile = driverProvider.profile;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.person, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(l10n),
                                style: TextStyle(fontSize: 13, color: secondaryColor),
                              ),
                              Text(
                                profile?.fullName ?? l10n.driver,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _isRefreshing
                              ? const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(Icons.refresh, color: secondaryColor, size: 22),
                                  onPressed: _refreshData,
                                ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.notifications_none, color: secondaryColor, size: 22),
                            onPressed: () => context.push(RouteConstants.notifications),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Verification Pending Banner
                    if (profile != null && !profile.isVerified)
                      Container(
                        key: _tourKeys.verificationBannerKey,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.hourglass_top,
                                color: AppColors.warning,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.accountUnderReview,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.accountBeingVerified,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Tour Welcome Card
                    Consumer<TourProvider>(
                      builder: (context, tourProvider, _) {
                        if (profile != null &&
                            !profile.isVerified &&
                            tourProvider.shouldShowPrompt(profile.isVerified)) {
                          return TourWelcomeCard(
                            onStartTour: () => _startTour(tourProvider),
                            onSkip: () => tourProvider.skipTour(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    // Status Card
                    Container(
                      key: _tourKeys.onlineToggleKey,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isOnline ? AppColors.primary.withValues(alpha: 0.08) : surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isOnline ? AppColors.primary.withValues(alpha: 0.3) : borderColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isOnline
                                  ? AppColors.primary.withValues(alpha: 0.15)
                                  : borderColor.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isOnline ? Icons.wifi : Icons.wifi_off,
                              color: isOnline ? AppColors.primary : secondaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isOnline ? l10n.youAreOnline : l10n.youAreOffline,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isOnline ? AppColors.primary : textColor,
                                  ),
                                ),
                                Text(
                                  isOnline
                                      ? (driverProvider.currentPlaceName ?? l10n.receivingOrders)
                                      : l10n.goOnlineToStart,
                                  style: TextStyle(fontSize: 13, color: secondaryColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          driverProvider.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                )
                              : Switch(
                                  value: isOnline,
                                  onChanged: (_) => _toggleOnline(driverProvider, orderProvider),
                                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                                  activeThumbColor: AppColors.primary,
                                ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // New Order Card
                    if (orderProvider.pendingOrder != null)
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _showNewOrderAnimation ? _pulseAnimation.value : 1.0,
                            child: child,
                          );
                        },
                        child: _buildNewOrderCard(
                          orderProvider.pendingOrder!,
                          orderProvider,
                          textColor,
                          secondaryColor,
                          surfaceColor,
                          borderColor,
                          l10n,
                        ),
                      ),

                    // Active Order Card
                    if (orderProvider.activeOrder != null)
                      _buildActiveOrderCard(
                        context,
                        orderProvider.activeOrder!,
                        orderProvider,
                        textColor,
                        secondaryColor,
                        surfaceColor,
                        borderColor,
                        l10n,
                      ),

                    // Stats Card
                    Container(
                      key: _tourKeys.statsCardKey,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.insert_chart_outlined, size: 16, color: secondaryColor),
                              const SizedBox(width: 6),
                              Text(
                                l10n.todayEarnings,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: secondaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatItem(
                                  Icons.receipt_long,
                                  '${orderProvider.totalOrders}',
                                  l10n.orders,
                                  AppColors.primary,
                                  textColor,
                                  secondaryColor,
                                ),
                              ),
                              Container(width: 1, height: 40, color: borderColor),
                              Expanded(
                                child: _buildStatItem(
                                  Icons.attach_money,
                                  '\$${orderProvider.totalEarnings.toStringAsFixed(0)}',
                                  l10n.earnings_label,
                                  AppColors.success,
                                  textColor,
                                  secondaryColor,
                                ),
                              ),
                              Container(width: 1, height: 40, color: borderColor),
                              Expanded(
                                child: _buildStatItem(
                                  Icons.star_rounded,
                                  profile?.formattedRating ?? '0.0',
                                  l10n.rating,
                                  AppColors.warning,
                                  textColor,
                                  secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Active Orders Header
                    if (orderProvider.activeOrders.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.local_shipping, size: 16, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Text(
                                l10n.currentOrders,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.go(RouteConstants.orders),
                            child: Row(
                              children: [
                                Text(
                                  l10n.seeAll,
                                  style: const TextStyle(fontSize: 13, color: AppColors.primary),
                                ),
                                const SizedBox(width: 2),
                                const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primary),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Active Orders List
                      ...orderProvider.activeOrders.map((order) => _buildActiveOrderListItem(
                        order,
                        textColor,
                        secondaryColor,
                        surfaceColor,
                        borderColor,
                      )),
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color iconColor,
    Color textColor,
    Color secondaryColor,
  ) {
    return Column(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: textColor),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: secondaryColor)),
      ],
    );
  }

  Widget _buildNewOrderCard(
    OrderModel order,
    OrderProvider orderProvider,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    return GestureDetector(
      onTap: () => context.push(RouteConstants.orderDetailPath(order.id)),
      child: Container(
        key: _tourKeys.newOrderCardKey,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border.all(color: AppColors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping, size: 14, color: AppColors.primary),
                    const SizedBox(width: 5),
                    Text(
                      l10n.newOrderTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                order.formattedPrice,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Route info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.route, size: 12, color: AppColors.info),
                    const SizedBox(width: 4),
                    Text(
                      order.formattedDistance,
                      style: const TextStyle(fontSize: 12, color: AppColors.info, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, size: 12, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      '~${order.estimatedMinutes} min',
                      style: const TextStyle(fontSize: 12, color: AppColors.warning, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Locations
          Row(
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
                  Container(width: 2, height: 42, color: borderColor),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.2),
                      border: Border.all(color: AppColors.error, width: 2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pickup info
                    Text(
                      order.pickupName,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (order.pickupStreet != null || order.pickupCity != null)
                      Text(
                        [order.pickupStreet, order.pickupCity].where((e) => e != null).join(', '),
                        style: TextStyle(fontSize: 11, color: secondaryColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 10),
                    // Dropoff info
                    Text(
                      order.customerName,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (order.dropoffStreet != null || order.dropoffCity != null)
                      Text(
                        [order.dropoffStreet, order.dropoffCity].where((e) => e != null).join(', '),
                        style: TextStyle(fontSize: 11, color: secondaryColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: orderProvider.isLoading ? null : () => orderProvider.acceptOrder(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                disabledForegroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: orderProvider.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 18),
                        const SizedBox(width: 8),
                        Text(l10n.accept, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildActiveOrderCard(
    BuildContext context,
    OrderModel order,
    OrderProvider orderProvider,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    String statusText;
    String buttonText;
    IconData buttonIcon;
    VoidCallback? onButtonPressed;

    switch (order.status) {
      case OrderStatus.accepted:
        statusText = l10n.headToPickup;
        buttonText = l10n.onTheWay;
        buttonIcon = Icons.local_shipping;
        onButtonPressed = () => orderProvider.startDelivery();
        break;
      case OrderStatus.onTheWay:
        statusText = l10n.onTheWay;
        buttonText = l10n.markAsDelivered;
        buttonIcon = Icons.location_on;
        onButtonPressed = () => orderProvider.markDelivered();
        break;
      case OrderStatus.delivered:
        statusText = l10n.atDelivery;
        buttonText = l10n.orderCompleted;
        buttonIcon = Icons.check_circle;
        onButtonPressed = () => orderProvider.completeOrder();
        break;
      default:
        statusText = l10n.inProgress;
        buttonText = l10n.continueText;
        buttonIcon = Icons.arrow_forward;
        onButtonPressed = null;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order.id,
                    style: TextStyle(fontSize: 12, color: secondaryColor),
                  ),
                ],
              ),
              Text(
                order.formattedPrice,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Locations
          Row(
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
                  Container(width: 2, height: 22, color: borderColor),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.2),
                      border: Border.all(color: AppColors.error, width: 2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.pickupName,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      order.dropoffAddress,
                      style: TextStyle(fontSize: 14, color: secondaryColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push(RouteConstants.navigationPath(order.id)),
                  icon: const Icon(Icons.navigation_outlined, size: 16),
                  label: Text(l10n.navigate),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.info,
                    side: const BorderSide(color: AppColors.info),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push(RouteConstants.orderDetailPath(order.id)),
                  icon: const Icon(Icons.receipt_long_outlined, size: 16),
                  label: Text(l10n.details),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: secondaryColor,
                    side: BorderSide(color: borderColor),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
          if (onButtonPressed != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: orderProvider.isLoading ? null : onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                  disabledForegroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: orderProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(buttonIcon, size: 18),
                          const SizedBox(width: 8),
                          Text(buttonText, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveOrderListItem(
    OrderModel order,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    return GestureDetector(
      onTap: () => context.push(RouteConstants.orderDetailPath(order.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.local_shipping, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.pickupName,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              order.status.displayName,
                              style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.route, size: 12, color: secondaryColor),
                      const SizedBox(width: 4),
                      Text(
                        order.formattedDistance,
                        style: TextStyle(fontSize: 12, color: secondaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  order.formattedPrice,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(Icons.arrow_forward_ios, size: 14, color: secondaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
