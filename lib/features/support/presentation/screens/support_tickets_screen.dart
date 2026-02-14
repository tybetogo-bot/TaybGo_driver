import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/support_provider.dart';
import '../../data/models/support_ticket_model.dart';

class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupportProvider>().fetchTickets();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SupportProvider>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.supportTickets),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => context.push(RouteConstants.supportCreate),
        child: Icon(
          Icons.add,
          color: isDark ? Colors.black : Colors.white,
        ),
      ),
      body: Column(
        children: [
          // Status filter chips
          _buildFilterBar(context, isDark, surfaceColor, borderColor),

          // Ticket list
          Expanded(
            child: Consumer<SupportProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null && provider.tickets.isEmpty) {
                  return _buildErrorState(
                    provider.error!,
                    textColor,
                    secondaryColor,
                    l10n,
                    () => provider.fetchTickets(),
                  );
                }

                if (provider.tickets.isEmpty) {
                  return _buildEmptyState(textColor, secondaryColor, l10n);
                }

                return RefreshIndicator(
                  onRefresh: () => provider.fetchTickets(),
                  color: AppColors.primary,
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.tickets.length +
                        (provider.isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index >= provider.tickets.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }

                      final ticket = provider.tickets[index];
                      return _buildTicketCard(
                        context,
                        ticket,
                        isDark,
                        textColor,
                        secondaryColor,
                        surfaceColor,
                        borderColor,
                        l10n,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<SupportProvider>();

    final filters = <(TicketStatus?, String)>[
      (null, l10n.supportFilterAll),
      (TicketStatus.open, l10n.supportFilterOpen),
      (TicketStatus.inProgress, l10n.supportFilterInProgress),
      (TicketStatus.closed, l10n.supportFilterClosed),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((filter) {
          final isSelected = provider.statusFilter == filter.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter.$2),
              selected: isSelected,
              onSelected: (_) => provider.setStatusFilter(filter.$1),
              selectedColor: AppColors.primary.withValues(alpha: 0.15),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.darkText : AppColors.lightText),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : borderColor,
              ),
              backgroundColor: surfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    SupportTicket ticket,
    bool isDark,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
    AppLocalizations l10n,
  ) {
    return GestureDetector(
      onTap: () => context.push(
        RouteConstants.supportTicketDetailPath(ticket.id.toString()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: subject + status badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    ticket.subject,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusBadge(ticket.status, l10n),
              ],
            ),
            const SizedBox(height: 8),
            // Ticket ID + priority
            Row(
              children: [
                Text(
                  '#${ticket.id}',
                  style: TextStyle(fontSize: 12, color: secondaryColor),
                ),
                const SizedBox(width: 12),
                _buildPriorityIndicator(ticket.priority, l10n),
                const Spacer(),
                Text(
                  _formatDate(ticket.updatedAt),
                  style: TextStyle(fontSize: 12, color: secondaryColor),
                ),
              ],
            ),
            if (ticket.orderDisplay != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.receipt_outlined,
                      size: 14, color: secondaryColor),
                  const SizedBox(width: 4),
                  Text(
                    '${l10n.orderId}: ${ticket.orderDisplay}',
                    style: TextStyle(fontSize: 12, color: secondaryColor),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TicketStatus status, AppLocalizations l10n) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case TicketStatus.open:
        bgColor = AppColors.info.withValues(alpha: 0.1);
        textColor = AppColors.info;
        label = l10n.supportStatusOpen;
      case TicketStatus.inProgress:
        bgColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        label = l10n.supportStatusInProgress;
      case TicketStatus.closed:
        bgColor = AppColors.offline.withValues(alpha: 0.1);
        textColor = AppColors.offline;
        label = l10n.supportStatusClosed;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(
      TicketPriority priority, AppLocalizations l10n) {
    Color color;
    String label;

    switch (priority) {
      case TicketPriority.low:
        color = AppColors.success;
        label = l10n.supportPriorityLow;
      case TicketPriority.medium:
        color = AppColors.warning;
        label = l10n.supportPriorityMedium;
      case TicketPriority.high:
        color = AppColors.error;
        label = l10n.supportPriorityHigh;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    Color textColor,
    Color secondaryColor,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.support_agent, size: 64, color: secondaryColor),
          const SizedBox(height: 16),
          Text(
            l10n.supportNoTickets,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.supportNoTicketsDesc,
            style: TextStyle(fontSize: 14, color: secondaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    String error,
    Color textColor,
    Color secondaryColor,
    AppLocalizations l10n,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              error,
              style: TextStyle(fontSize: 14, color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return AppLocalizations.of(context)!.justNow;
    if (diff.inHours < 1) {
      return AppLocalizations.of(context)!.minutesAgo(diff.inMinutes);
    }
    if (diff.inDays < 1) {
      return AppLocalizations.of(context)!.hoursAgo(diff.inHours);
    }
    if (diff.inDays < 7) {
      return AppLocalizations.of(context)!.daysAgo(diff.inDays);
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}
