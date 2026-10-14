import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

/// The inbox count stays visible until notifications are marked read.
class NotificationUnreadPill extends StatefulWidget {
  const NotificationUnreadPill({
    super.key,
    required this.unreadCount,
    required this.onPressed,
    this.isReady = true,
  });

  final int unreadCount;
  final bool isReady;
  final VoidCallback onPressed;

  @override
  State<NotificationUnreadPill> createState() => _NotificationUnreadPillState();
}

class _NotificationUnreadPillState extends State<NotificationUnreadPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _arrival = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );

  @override
  void didUpdateWidget(NotificationUnreadPill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isReady &&
        oldWidget.isReady &&
        widget.unreadCount > oldWidget.unreadCount &&
        !MediaQuery.disableAnimationsOf(context)) {
      _arrival.forward(from: 0);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _arrival.stop();
      _arrival.value = 0;
    }
  }

  @override
  void dispose() {
    _arrival.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasUnread = widget.unreadCount > 0;
    final count = widget.unreadCount > 99 ? '99+' : '${widget.unreadCount}';
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final foreground = hasUnread
        ? (isDark ? const Color(0xFF77E5A3) : const Color(0xFF087D3D))
        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
    final background = hasUnread
        ? (isDark ? const Color(0xFF153323) : const Color(0xFFE2F8EB))
        : (isDark ? AppColors.darkSurface : AppColors.lightSurface);
    final label = !widget.isReady
        ? l10n.notifications
        : hasUnread
        ? l10n.notificationsNewCount(count)
        : l10n.notificationsAllRead;
    final semantics = hasUnread
        ? l10n.notificationsUnreadCount(widget.unreadCount)
        : widget.isReady
        ? l10n.notificationsAllRead
        : l10n.notifications;

    return Semantics(
      button: true,
      onTap: widget.onPressed,
      label: '${l10n.notifications}, $semantics',
      child: Tooltip(
        message: '${l10n.notifications}, $semantics',
        child: AnimatedBuilder(
          animation: _arrival,
          builder: (context, child) {
            final progress = reducedMotion ? 0.0 : _arrival.value;
            final angle =
                math.sin(progress * math.pi * 5) *
                math.pow(1 - progress, 2) *
                0.25;
            final scale = 1 + math.sin(progress * math.pi) * 0.035;
            return Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: reducedMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(13),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: widget.onPressed,
                    excludeFromSemantics: true,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 44,
                        minWidth: 44,
                        maxWidth: 144,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 10,
                        ),
                        child: ExcludeSemantics(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Transform.rotate(
                                angle: angle,
                                alignment: const Alignment(0, -0.7),
                                child: Icon(
                                  Icons.notifications_none_rounded,
                                  size: 22,
                                  color: foreground,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Flexible(
                                child: Text(
                                  label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: foreground,
                                  ),
                                ),
                              ),
                              if (hasUnread) ...[
                                const SizedBox(width: 7),
                                Container(
                                  key: const ValueKey(
                                    'notification-unread-dot',
                                  ),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFFFF7D90)
                                        : const Color(0xFFD84660),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
