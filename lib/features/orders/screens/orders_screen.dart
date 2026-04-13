import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/driver_provider.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../tour/tour_keys.dart';
import '../models/order_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  Timer? _refreshTimer;

  // Tour keys from singleton
  final _tourKeys = TourKeys.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Start auto-refresh every 5 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      context.read<OrderProvider>().fetchOrderHistory();
    });
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);

    await context.read<OrderProvider>().fetchOrderHistory();

    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _tabController.dispose();
    super.dispose();
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
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.receipt_long,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(l10n.orders),
          ],
        ),
        actions: [
          _isRefreshing
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.refresh, color: secondaryColor),
                  onPressed: _refreshData,
                ),
        ],
        bottom: TabBar(
          key: _tourKeys.tabBarKey,
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: secondaryColor,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: borderColor,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_shipping_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text(l10n.currentOrders),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.history, size: 18),
                  const SizedBox(width: 6),
                  Text(l10n.orderHistory),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveOrders(
            isDark,
            textColor,
            secondaryColor,
            surfaceColor,
            borderColor,
            l10n,
          ),
          _buildHistory(
            textColor,
            secondaryColor,
            surfaceColor,
            borderColor,
            l10n,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrders(
    bool isDark,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        final activeOrder = orderProvider.activeOrder;

        if (activeOrder == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delivery_dining,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.noActiveOrders,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: context.watch<DriverProvider>().isOnline
                        ? AppColors.success.withValues(alpha: 0.1)
                        : surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        context.watch<DriverProvider>().isOnline
                            ? Icons.wifi
                            : Icons.wifi_off,
                        size: 14,
                        color: context.watch<DriverProvider>().isOnline
                            ? AppColors.success
                            : secondaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        context.watch<DriverProvider>().isOnline
                            ? l10n.waitingForOrders
                            : l10n.youAreOffline,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.watch<DriverProvider>().isOnline
                              ? AppColors.success
                              : secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildOrderCard(
              order: activeOrder,
              textColor: textColor,
              secondaryColor: secondaryColor,
              surfaceColor: surfaceColor,
              borderColor: borderColor,
            ),
          ],
        );
      },
    );
  }

  Widget _buildHistory(
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        final history = orderProvider.orderHistory;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (history.isEmpty) ...[
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.history,
                        size: 40,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noOrdersYet,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your orders will appear here',
                      style: TextStyle(fontSize: 13, color: secondaryColor),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Icon(Icons.history, size: 16, color: secondaryColor),
                  const SizedBox(width: 6),
                  Text(
                    'Recent',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ...history.map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildOrderCard(
                    order: order,
                    textColor: textColor,
                    secondaryColor: secondaryColor,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildOrderCard({
    required OrderModel order,
    required Color textColor,
    required Color secondaryColor,
    required Color surfaceColor,
    required Color borderColor,
  }) {
    final l10n = AppLocalizations.of(context)!;
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (order.status) {
      case OrderStatus.completed:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        break;
      case OrderStatus.cancelled:
        statusColor = AppColors.error;
        statusIcon = Icons.cancel;
        break;
      case OrderStatus.rejected:
        statusColor = AppColors.error;
        statusIcon = Icons.cancel;
        break;
      case OrderStatus.accepted:
        statusColor = AppColors.info;
        statusIcon = Icons.check;
        break;
      case OrderStatus.onTheWay:
        statusColor = AppColors.primary;
        statusIcon = Icons.local_shipping;
        break;
      case OrderStatus.delivered:
        statusColor = AppColors.success;
        statusIcon = Icons.inventory;
        break;
      default:
        statusColor = AppColors.warning;
        statusIcon = Icons.hourglass_empty;
    }

    statusText = order.status.localizedName(l10n);

    return GestureDetector(
      onTap: () => context.push(RouteConstants.orderDetailPath(order.id)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  order.id,
                  style: TextStyle(fontSize: 12, color: secondaryColor),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
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
                    Container(width: 2, height: 20, color: borderColor),
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
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        order.dropoffAddress,
                        style: TextStyle(fontSize: 14, color: secondaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Footer
            Row(
              children: [
                Text(
                  order.formattedPrice,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 14, color: secondaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
