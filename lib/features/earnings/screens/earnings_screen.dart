import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../tour/tour_keys.dart';
import '../../orders/models/order_model.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  bool _isRefreshing = false;

  // Tour keys from singleton
  final _tourKeys = TourKeys.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.account_balance_wallet, color: AppColors.success, size: 18),
            ),
            const SizedBox(width: 10),
            Text(l10n.earnings_label),
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
                      color: AppColors.success,
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.refresh, color: secondaryColor),
                  onPressed: _refreshData,
                ),
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, _) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = _calculateStats(orderProvider.allOrdersForEarnings);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total earnings card
                Container(
                  key: _tourKeys.totalEarningsKey,
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: stats.orders == 0
                      ? _buildNoDataView(secondaryColor, l10n)
                      : Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.trending_up, size: 16, color: secondaryColor),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.totalEarnings,
                                  style: TextStyle(fontSize: 14, color: secondaryColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '\$${stats.earnings.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 20),

                // Stats grid
                if (stats.orders > 0) ...[
                  Row(
                    key: _tourKeys.statsGridKey,
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          Icons.receipt_long,
                          '${stats.orders}',
                          l10n.orders,
                          AppColors.primary,
                          surfaceColor,
                          textColor,
                          secondaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          Icons.local_shipping,
                          stats.orders > 0
                              ? '\$${(stats.earnings / stats.orders).toStringAsFixed(2)}'
                              : '--',
                          l10n.avgPerOrder,
                          AppColors.success,
                          surfaceColor,
                          textColor,
                          secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoDataView(Color secondaryColor, AppLocalizations l10n) {
    return Column(
      children: [
        Icon(
          Icons.inbox_outlined,
          size: 48,
          color: secondaryColor.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.noEarningsData,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: secondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.completeOrdersToSeeEarnings,
          style: TextStyle(
            fontSize: 13,
            color: secondaryColor.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color iconColor,
    Color bgColor,
    Color textColor,
    Color secondaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: secondaryColor),
          ),
        ],
      ),
    );
  }

  _EarningsStats _calculateStats(List<OrderModel> orders) {
    double totalEarnings = 0;
    int totalOrders = 0;

    for (final order in orders) {
      // Include accepted, onTheWay, delivered, and completed orders in earnings
      final isActiveOrCompleted = order.status == OrderStatus.accepted ||
          order.status == OrderStatus.onTheWay ||
          order.status == OrderStatus.delivered ||
          order.status == OrderStatus.completed;
      if (!isActiveOrCompleted) continue;

      // Use deliveryFee as driver earnings
      totalEarnings += order.deliveryFee;
      totalOrders++;
    }

    return _EarningsStats(totalEarnings, totalOrders);
  }
}

class _EarningsStats {
  final double earnings;
  final int orders;

  _EarningsStats(this.earnings, this.orders);
}
