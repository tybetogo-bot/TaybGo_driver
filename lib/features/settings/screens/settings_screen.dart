import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/providers/tour_provider.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _orderNotifications = true;
  bool _sound = true;
  bool _vibration = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final tourProvider = Provider.of<TourProvider>(context, listen: false);

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
              child: const Icon(Icons.settings, color: AppColors.primary, size: 18),
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
          // Language
          Row(
            children: [
              Icon(Icons.language, size: 16, color: secondaryColor),
              const SizedBox(width: 6),
              Text(l10n.language, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: secondaryColor)),
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
                _buildLanguageOption(l10n.english, '\u{1F1EC}\u{1F1E7}', const Locale('en'), localeProvider, textColor, borderColor),
                Divider(height: 1, indent: 56, color: borderColor),
                _buildLanguageOption(l10n.german, '\u{1F1E9}\u{1F1EA}', const Locale('de'), localeProvider, textColor, borderColor),
                Divider(height: 1, indent: 56, color: borderColor),
                _buildLanguageOption(l10n.french, '\u{1F1EB}\u{1F1F7}', const Locale('fr'), localeProvider, textColor, borderColor),
                Divider(height: 1, indent: 56, color: borderColor),
                _buildLanguageOption(l10n.arabic, '\u{1F1F8}\u{1F1E6}', const Locale('ar'), localeProvider, textColor, borderColor),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Tour (only when driver has no orders yet)
          Consumer<OrderProvider>(
            builder: (context, orderProvider, _) {
              if (orderProvider.totalOrders > 0) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school_outlined, size: 16, color: secondaryColor),
                      const SizedBox(width: 6),
                      Text(l10n.tourWelcomeTitle, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: secondaryColor)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.tourWelcomeDesc,
                          style: TextStyle(fontSize: 13, color: secondaryColor),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              context.go(RouteConstants.home);
                              await Future.delayed(const Duration(milliseconds: 350));
                              await tourProvider.startTour();
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: Text(l10n.tourStartBtn),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),

          // Appearance
          Row(
            children: [
              Icon(Icons.palette_outlined, size: 16, color: secondaryColor),
              const SizedBox(width: 6),
              Text(l10n.theme, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: secondaryColor)),
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
                _buildThemeOption(l10n.lightMode, Icons.light_mode_outlined, AppThemeMode.light, AppColors.warning, themeProvider, textColor, borderColor),
                Divider(height: 1, indent: 56, color: borderColor),
                _buildThemeOption(l10n.darkMode, Icons.dark_mode_outlined, AppThemeMode.dark, AppColors.info, themeProvider, textColor, borderColor),
                Divider(height: 1, indent: 56, color: borderColor),
                _buildThemeOption(l10n.systemDefault, Icons.settings_suggest_outlined, AppThemeMode.system, AppColors.primary, themeProvider, textColor, borderColor),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Notifications
          Row(
            children: [
              Icon(Icons.notifications_outlined, size: 16, color: secondaryColor),
              const SizedBox(width: 6),
              Text(l10n.notifications, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: secondaryColor)),
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
                  _orderNotifications,
                  (v) => setState(() => _orderNotifications = v),
                  textColor,
                  secondaryColor,
                ),
                Divider(height: 1, indent: 56, color: borderColor),
                _buildSwitchOption(
                  Icons.volume_up_outlined,
                  AppColors.info,
                  l10n.soundEnabled,
                  null,
                  _sound,
                  (v) => setState(() => _sound = v),
                  textColor,
                  secondaryColor,
                ),
                Divider(height: 1, indent: 56, color: borderColor),
                _buildSwitchOption(
                  Icons.vibration,
                  AppColors.warning,
                  l10n.vibrationEnabled,
                  null,
                  _vibration,
                  (v) => setState(() => _vibration = v),
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
                        child: const Icon(Icons.local_shipping, color: AppColors.primary, size: 24),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(l10n.appName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
                const SizedBox(height: 4),
                Text(l10n.version('1.0.0'), style: TextStyle(fontSize: 12, color: secondaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language, String flag, Locale locale, LocaleProvider provider, Color textColor, Color borderColor) {
    final selected = provider.locale.languageCode == locale.languageCode;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(flag, style: const TextStyle(fontSize: 18)),
      ),
      title: Text(language, style: TextStyle(fontSize: 15, color: textColor)),
      trailing: selected
          ? Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 14),
            )
          : null,
      onTap: () => provider.setLocale(locale),
    );
  }

  Widget _buildThemeOption(String title, IconData icon, AppThemeMode mode, Color iconColor, ThemeProvider provider, Color textColor, Color borderColor) {
    final selected = provider.themeMode == mode;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: TextStyle(fontSize: 15, color: textColor)),
      trailing: selected
          ? Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 14),
            )
          : null,
      onTap: () => provider.setThemeMode(mode),
    );
  }

  Widget _buildSwitchOption(IconData icon, Color iconColor, String title, String? subtitle, bool value, ValueChanged<bool> onChanged, Color textColor, Color secondaryColor) {
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
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 12, color: secondaryColor)) : null,
      value: value,
      onChanged: onChanged,
      activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
      activeThumbColor: AppColors.primary,
    );
  }
}
