import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/config/release_info.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/notification_settings_provider.dart';
import '../../../core/services/notification_preferences_service.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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

    final notificationSettingsProvider =
        Provider.of<NotificationSettingsProvider>(context);
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
                Icons.settings,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(l10n.settings),
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Notifications
          Row(
            children: [
              Icon(
                Icons.notifications_outlined,
                size: 16,
                color: secondaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.notifications,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildSwitchOption(
                  Icons.notifications_active_outlined,
                  AppColors.primary,
                  l10n.orderNotifications,
                  null,
                  notificationSettingsProvider.orderNotificationsEnabled,
                  notificationSettingsProvider.setOrderNotificationsEnabled,
                  textColor,
                  secondaryColor,
                ),
                Divider(height: 1, indent: 56, color: borderColor),
                _buildSwitchOption(
                  Icons.volume_up_outlined,
                  AppColors.info,
                  l10n.soundEnabled,
                  null,
                  notificationSettingsProvider.soundEnabled,
                  notificationSettingsProvider.setSoundEnabled,
                  textColor,
                  secondaryColor,
                ),
                Divider(height: 1, indent: 56, color: borderColor),
                _buildRepeatCountOption(
                  context: context,
                  title: l10n.notificationSoundRepeats,
                  subtitle: notificationSettingsProvider.soundEnabled
                      ? l10n.notificationSoundRepeatsEnabledDesc(
                          notificationSettingsProvider.repeatCount,
                        )
                      : l10n.notificationSoundRepeatsDisabledDesc,
                  value: notificationSettingsProvider.repeatCount,
                  enabled: notificationSettingsProvider.soundEnabled,
                  textColor: textColor,
                  secondaryColor: secondaryColor,
                ),
                Divider(height: 1, indent: 56, color: borderColor),
                _buildSwitchOption(
                  Icons.vibration,
                  AppColors.warning,
                  l10n.vibrationEnabled,
                  null,
                  notificationSettingsProvider.vibrationEnabled,
                  notificationSettingsProvider.setVibrationEnabled,
                  textColor,
                  secondaryColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Info
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/icons/TaybGo_green.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.local_shipping,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.appName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.version(ReleaseInfo.version),
                  style: TextStyle(fontSize: 12, color: secondaryColor),
                ),
                const SizedBox(height: 2),
                Text(
                  ReleaseInfo.releaseDate,
                  style: TextStyle(fontSize: 11, color: secondaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchOption(
    IconData icon,
    Color iconColor,
    String title,
    String? subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    Color textColor,
    Color secondaryColor,
  ) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: TextStyle(fontSize: 15, color: textColor)),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: secondaryColor),
            )
          : null,
      value: value,
      onChanged: onChanged,
      activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
      activeThumbColor: AppColors.primary,
    );
  }

  Widget _buildRepeatCountOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required int value,
    required bool enabled,
    required Color textColor,
    required Color secondaryColor,
  }) {
    return ListTile(
      enabled: enabled,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: enabled ? 0.1 : 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.repeat_rounded,
          color: enabled ? AppColors.success : secondaryColor,
          size: 20,
        ),
      ),
      title: Text(title, style: TextStyle(fontSize: 15, color: textColor)),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: secondaryColor),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          '$value x',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: enabled ? () => _showRepeatCountPicker(context, value) : null,
    );
  }

  Future<void> _showRepeatCountPicker(
    BuildContext context,
    int currentValue,
  ) async {
    final provider = context.read<NotificationSettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
        final textColor = isDark ? AppColors.darkText : AppColors.lightText;
        final secondaryColor = isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary;
        final surfaceColor = isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface;
        final borderColor = isDark
            ? AppColors.darkBorder
            : AppColors.lightBorder;

        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.repeat_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.notificationSoundRepeats,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.notificationSoundRepeatsPickerDesc,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 18),
                  for (
                    int repeat = NotificationPreferencesService.minRepeatCount;
                    repeat <= NotificationPreferencesService.maxRepeatCount;
                    repeat++
                  )
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildRepeatChoiceCard(
                        repeat: repeat,
                        selected: currentValue == repeat,
                        label: repeat == 1
                            ? l10n.notificationRepeatTime
                            : l10n.notificationRepeatTimes(repeat),
                        textColor: textColor,
                        secondaryColor: secondaryColor,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        onTap: () async {
                          await provider.setRepeatCount(repeat);
                          if (sheetContext.mounted) {
                            Navigator.of(sheetContext).pop();
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRepeatChoiceCard({
    required int repeat,
    required bool selected,
    required String label,
    required Color textColor,
    required Color secondaryColor,
    required Color surfaceColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.12)
              : surfaceColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.primary : borderColor,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${repeat}x',
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? AppColors.primary : secondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
