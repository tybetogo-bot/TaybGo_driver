import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/framework_locale_support.dart';
import '../../../core/providers/earnings_provider.dart';
import '../../../core/providers/tour_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../tour/tour_keys.dart';
import '../models/earnings_model.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

enum _DateFilter { today, week, month, custom }

class _EarningsScreenState extends State<EarningsScreen> {
  bool _isRefreshing = false;
  _DateFilter _selectedFilter = _DateFilter.month;
  DateTimeRange? _customRange;

  // Tour keys from singleton
  final _tourKeys = TourKeys.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilter(_selectedFilter);
    });
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);

    await context.read<EarningsProvider>().refresh();

    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  void _applyFilter(_DateFilter filter) {
    final now = DateTime.now();
    String? from;
    String? to;

    switch (filter) {
      case _DateFilter.today:
        from = DateTime(now.year, now.month, now.day).toIso8601String();
        to = now.toIso8601String();
      case _DateFilter.week:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        from = DateTime(weekStart.year, weekStart.month, weekStart.day)
            .toIso8601String();
        to = now.toIso8601String();
      case _DateFilter.month:
        from = DateTime(now.year, now.month, 1).toIso8601String();
        to = now.toIso8601String();
      case _DateFilter.custom:
        if (_customRange != null) {
          from = _customRange!.start.toIso8601String();
          to = DateTime(
            _customRange!.end.year,
            _customRange!.end.month,
            _customRange!.end.day,
            23, 59, 59,
          ).toIso8601String();
        }
    }

    setState(() => _selectedFilter = filter);
    context.read<EarningsProvider>().fetchEarnings(from: from, to: to);
  }

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      initialDateRange: _customRange ??
          DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: now,
          ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.success,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      _customRange = picked;
      _applyFilter(_DateFilter.custom);
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
              child: const Icon(
                Icons.account_balance_wallet,
                color: AppColors.success,
                size: 18,
              ),
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
      body: Consumer<EarningsProvider>(
        builder: (context, earningsProvider, _) {
          final isTourActive = context.watch<TourProvider>().isTourActive;

          if (earningsProvider.isLoading && !isTourActive) {
            return const Center(child: CircularProgressIndicator());
          }

          final summary = earningsProvider.summary;
          final entries = earningsProvider.entries;
          final hasData = summary != null && summary.totalOrders > 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date filter chips
                _buildDateFilters(surfaceColor, textColor, secondaryColor, l10n),
                const SizedBox(height: 16),

                // Total earnings card
                Container(
                  key: _tourKeys.totalEarningsKey,
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: !hasData && !isTourActive
                      ? _buildNoDataView(secondaryColor, l10n)
                      : Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  size: 16,
                                  color: secondaryColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.totalEarnings,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _filterLabel(l10n),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '\$${(summary?.totalEarnings ?? 0).toStringAsFixed(2)}',
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
                if (hasData || isTourActive) ...[
                  Container(
                    key: _tourKeys.statsGridKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                Icons.receipt_long,
                                '${summary?.totalOrders ?? 0}',
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
                                Icons.local_shipping_outlined,
                                '\$${(summary?.totalDeliveryFees ?? 0).toStringAsFixed(2)}',
                                l10n.deliveryFee,
                                AppColors.info,
                                surfaceColor,
                                textColor,
                                secondaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                Icons.volunteer_activism,
                                '\$${(summary?.totalTips ?? 0).toStringAsFixed(2)}',
                                l10n.tip,
                                AppColors.warning,
                                surfaceColor,
                                textColor,
                                secondaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                Icons.trending_up,
                                (summary?.totalOrders ?? 0) > 0
                                    ? '\$${(summary!.totalEarnings / summary.totalOrders).toStringAsFixed(2)}'
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
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Earnings list
                  if (entries.isNotEmpty) ...[
                    Text(
                      l10n.earningsReceived,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...entries.map(
                      (entry) => _buildEarningTile(
                        entry,
                        surfaceColor,
                        textColor,
                        secondaryColor,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _filterLabel(AppLocalizations l10n) {
    final locale = FrameworkLocaleSupport.dateFormattingLocale(
      Localizations.localeOf(context),
    );
    switch (_selectedFilter) {
      case _DateFilter.today:
        return l10n.today;
      case _DateFilter.week:
        return l10n.week;
      case _DateFilter.month:
        return DateFormat.MMMM(locale).format(DateTime.now());
      case _DateFilter.custom:
        if (_customRange != null) {
          final fmt = DateFormat.MMMd(locale);
          return '${fmt.format(_customRange!.start)} – ${fmt.format(_customRange!.end)}';
        }
        return '';
    }
  }

  Widget _buildDateFilters(
    Color surfaceColor,
    Color textColor,
    Color secondaryColor,
    AppLocalizations l10n,
  ) {
    final filters = {
      _DateFilter.today: l10n.today,
      _DateFilter.week: l10n.week,
      _DateFilter.month: l10n.month,
    };

    return Row(
      children: [
        ...filters.entries.map((e) {
          final isSelected = _selectedFilter == e.key;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: ChoiceChip(
              label: Text(e.value),
              selected: isSelected,
              onSelected: (_) => _applyFilter(e.key),
              selectedColor: AppColors.success.withValues(alpha: 0.15),
              backgroundColor: surfaceColor,
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.success : secondaryColor,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppColors.success.withValues(alpha: 0.4)
                    : Colors.transparent,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              showCheckmark: false,
              visualDensity: VisualDensity.compact,
            ),
          );
        }),
        ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.date_range,
                size: 14,
                color: _selectedFilter == _DateFilter.custom
                    ? AppColors.success
                    : secondaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                _selectedFilter == _DateFilter.custom && _customRange != null
                    ? DateFormat.MMMd().format(_customRange!.start)
                    : '...',
              ),
            ],
          ),
          selected: _selectedFilter == _DateFilter.custom,
          onSelected: (_) => _pickCustomRange(),
          selectedColor: AppColors.success.withValues(alpha: 0.15),
          backgroundColor: surfaceColor,
          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: _selectedFilter == _DateFilter.custom
                ? FontWeight.w600
                : FontWeight.w400,
            color: _selectedFilter == _DateFilter.custom
                ? AppColors.success
                : secondaryColor,
          ),
          side: BorderSide(
            color: _selectedFilter == _DateFilter.custom
                ? AppColors.success.withValues(alpha: 0.4)
                : Colors.transparent,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          showCheckmark: false,
          visualDensity: VisualDensity.compact,
        ),
      ],
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
          Text(label, style: TextStyle(fontSize: 12, color: secondaryColor)),
        ],
      ),
    );
  }

  Widget _buildEarningTile(
    EarningEntry entry,
    Color surfaceColor,
    Color textColor,
    Color secondaryColor,
  ) {
    final icon = switch (entry.orderType.apiValue) {
      'FOOD' => Icons.restaurant,
      'TAXI' => Icons.local_taxi,
      'SHIPPING' => Icons.inventory_2_outlined,
      _ => Icons.receipt_long,
    };

    final iconColor = switch (entry.orderType.apiValue) {
      'FOOD' => AppColors.warning,
      'TAXI' => AppColors.info,
      'SHIPPING' => AppColors.primary,
      _ => AppColors.success,
    };

    final dateStr = entry.earnedAt != null
        ? DateFormat.MMMd(
            FrameworkLocaleSupport.dateFormattingLocale(
              Localizations.localeOf(context),
            ),
          ).add_jm().format(entry.earnedAt!)
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.restaurantName ?? '#${entry.orderId}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  dateStr,
                  style: TextStyle(fontSize: 12, color: secondaryColor),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${entry.earningAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
              if (entry.tip > 0)
                Text(
                  '+\$${entry.tip.toStringAsFixed(2)} tip',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.warning,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
