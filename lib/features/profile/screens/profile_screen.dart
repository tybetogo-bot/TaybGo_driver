import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/driver_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final driverProvider = context.read<DriverProvider>();
      driverProvider.fetchProfile().then((_) {
        if (!mounted) return;
        // If no profile exists, redirect to application form
        if (driverProvider.profileExists == false) {
          context.go(RouteConstants.application);
        }
      });
    });
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
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final driverProvider = Provider.of<DriverProvider>(context);
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
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.profile,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Profile Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: profile?.avatarUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  profile!.avatarUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.person,
                                        size: 36,
                                        color: AppColors.primary,
                                      ),
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 36,
                                color: AppColors.primary,
                              ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        profile?.fullName ?? l10n.driver,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.phone_android,
                            size: 14,
                            color: secondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            profile?.phone ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      if (profile?.isVerified == true) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.verified,
                                size: 14,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.verified,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      // Stats Row
                      Row(
                        children: [
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

                // Settings Section
                Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        Icons.language,
                        l10n.language,
                        localeProvider.getLanguageName(
                          localeProvider.locale.languageCode,
                        ),
                        AppColors.info,
                        textColor,
                        secondaryColor,
                        borderColor,
                        false,
                        () =>
                            _showLanguagePicker(context, localeProvider, l10n),
                      ),
                      _buildMenuItem(
                        Icons.contrast,
                        l10n.theme,
                        themeProvider.themeModeName,
                        AppColors.warning,
                        textColor,
                        secondaryColor,
                        borderColor,
                        true,
                        () => _showThemePicker(context, themeProvider, l10n),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Logout
                Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: _buildMenuItem(
                    Icons.logout,
                    l10n.logout,
                    null,
                    AppColors.error,
                    AppColors.error,
                    secondaryColor,
                    borderColor,
                    true,
                    () => _showLogoutDialog(context, l10n),
                  ),
                ),

                const SizedBox(height: 24),

                // Version
                Center(
                  child: Text(
                    l10n.version('1.0.0'),
                    style: TextStyle(fontSize: 12, color: secondaryColor),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
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
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: secondaryColor)),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String? value,
    Color iconColor,
    Color textColor,
    Color secondaryColor,
    Color borderColor,
    bool isLast,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          title: Text(title, style: TextStyle(fontSize: 15, color: textColor)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value != null)
                Text(
                  value,
                  style: TextStyle(fontSize: 14, color: secondaryColor),
                ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 20, color: secondaryColor),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, indent: 56, color: borderColor),
      ],
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    LocaleProvider localeProvider,
    AppLocalizations l10n,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.language,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 16),
            ...['en', 'de', 'fr'].map(
              (code) => ListTile(
                onTap: () {
                  localeProvider.setLocale(Locale(code));
                  Navigator.pop(ctx);
                },
                leading: Icon(
                  localeProvider.locale.languageCode == code
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: AppColors.primary,
                ),
                title: Text(
                  localeProvider.getLanguageName(code),
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showThemePicker(
    BuildContext context,
    ThemeProvider themeProvider,
    AppLocalizations l10n,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.theme,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 16),
            ...[
              (AppThemeMode.system, l10n.systemDefault),
              (AppThemeMode.light, l10n.lightMode),
              (AppThemeMode.dark, l10n.darkMode),
            ].map(
              (option) => ListTile(
                onTap: () {
                  themeProvider.setThemeMode(option.$1);
                  Navigator.pop(ctx);
                },
                leading: Icon(
                  themeProvider.themeMode == option.$1
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: AppColors.primary,
                ),
                title: Text(
                  option.$2,
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.logout, color: AppColors.error, size: 20),
            ),
            const SizedBox(width: 12),
            Text(l10n.logout),
          ],
        ),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              context.read<DriverProvider>().clearProfile();
              await context.read<AuthProvider>().logout();
            },
            child: Text(
              l10n.logout,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
