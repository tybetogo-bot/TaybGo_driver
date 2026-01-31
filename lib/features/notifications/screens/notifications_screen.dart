import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final l10n = AppLocalizations.of(context)!;

    return Consumer<NotificationProvider>(
      builder: (context, provider, _) {
        final unreadCount = provider.unreadCount;
        final today = provider.todayNotifications;
        final yesterday = provider.yesterdayNotifications;
        final earlier = provider.earlierNotifications;
        final hasNotifications = provider.notifications.isNotEmpty;

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
                  child: const Icon(Icons.notifications, color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: 10),
                Text(l10n.notifications),
                if (unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.arrow_back, color: textColor, size: 18),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              if (hasNotifications)
                PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.more_vert, color: secondaryColor, size: 18),
                  ),
                  onSelected: (value) {
                    if (value == 'read') {
                      provider.markAllAsRead();
                    } else if (value == 'clear') {
                      _showClearConfirmation(context, l10n, provider);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'read',
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.done_all, size: 16, color: AppColors.success),
                          ),
                          const SizedBox(width: 12),
                          Text(l10n.markAllRead),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'clear',
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                          ),
                          const SizedBox(width: 12),
                          Text(l10n.clearAll, style: const TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          body: _buildBody(
            provider,
            today,
            yesterday,
            earlier,
            l10n,
            isDark,
            textColor,
            secondaryColor,
            surfaceColor,
            borderColor,
          ),
        );
      },
    );
  }

  Widget _buildBody(
    NotificationProvider provider,
    List<NotificationModel> today,
    List<NotificationModel> yesterday,
    List<NotificationModel> earlier,
    AppLocalizations l10n,
    bool isDark,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.failedToLoadNotifications,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                provider.error!,
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => provider.fetchNotifications(),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.notifications.isEmpty) {
      return _buildEmptyState(l10n, textColor, secondaryColor);
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchNotifications(),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          if (today.isNotEmpty) ...[
            _buildSectionHeader(l10n.today, Icons.today, secondaryColor),
            ...today.map((n) => _buildNotificationTile(
              n,
              provider,
              isDark,
              textColor,
              secondaryColor,
              surfaceColor,
              borderColor,
            )),
          ],
          if (yesterday.isNotEmpty) ...[
            _buildSectionHeader(l10n.yesterday, Icons.history, secondaryColor),
            ...yesterday.map((n) => _buildNotificationTile(
              n,
              provider,
              isDark,
              textColor,
              secondaryColor,
              surfaceColor,
              borderColor,
            )),
          ],
          if (earlier.isNotEmpty) ...[
            _buildSectionHeader(l10n.earlier, Icons.schedule, secondaryColor),
            ...earlier.map((n) => _buildNotificationTile(
              n,
              provider,
              isDark,
              textColor,
              secondaryColor,
              surfaceColor,
              borderColor,
            )),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n, Color textColor, Color secondaryColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noNotifications,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noNotificationsDesc,
              style: TextStyle(
                fontSize: 14,
                color: secondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color secondaryColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: secondaryColor),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
    NotificationModel notification,
    NotificationProvider provider,
    bool isDark,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    // Determine icon and color based on notification title/body content
    IconData icon;
    Color iconColor;

    final titleLower = notification.title.toLowerCase();
    final bodyLower = notification.body.toLowerCase();

    if (titleLower.contains('order') || bodyLower.contains('order') ||
        titleLower.contains('delivery') || bodyLower.contains('delivery')) {
      icon = Icons.delivery_dining;
      iconColor = AppColors.primary;
    } else if (titleLower.contains('earning') || bodyLower.contains('earning') ||
               titleLower.contains('payment') || bodyLower.contains('payment') ||
               titleLower.contains('paid') || bodyLower.contains('paid')) {
      icon = Icons.account_balance_wallet;
      iconColor = AppColors.success;
    } else if (titleLower.contains('bonus') || bodyLower.contains('bonus') ||
               titleLower.contains('promo') || bodyLower.contains('promo') ||
               titleLower.contains('offer') || bodyLower.contains('offer')) {
      icon = Icons.local_offer;
      iconColor = AppColors.warning;
    } else {
      icon = Icons.info_outline;
      iconColor = AppColors.info;
    }

    final timeAgo = _formatTimeAgo(notification.createdAt);

    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => provider.deleteNotification(notification.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: InkWell(
          onTap: () => provider.markAsRead(notification.id),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? surfaceColor
                  : AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: !notification.isRead
                  ? Border.all(color: AppColors.primary.withValues(alpha: 0.2))
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: 13,
                          color: secondaryColor,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          timeAgo,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: iconColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    final l10n = AppLocalizations.of(context)!;

    if (difference.inMinutes < 1) {
      return l10n.justNow;
    } else if (difference.inMinutes < 60) {
      return l10n.minutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return l10n.hoursAgo(difference.inHours);
    } else if (difference.inDays == 1) {
      return l10n.yesterday;
    } else if (difference.inDays < 7) {
      return l10n.daysAgo(difference.inDays);
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _showClearConfirmation(BuildContext context, AppLocalizations l10n, NotificationProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearAll),
        content: Text(l10n.clearAllNotificationsConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.clearAll();
            },
            child: Text(l10n.confirm, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
