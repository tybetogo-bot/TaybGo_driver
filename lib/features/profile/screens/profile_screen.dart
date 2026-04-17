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
import '../../tour/tour_keys.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Tour keys from singleton
  final _tourKeys = TourKeys.instance;

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
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Avatar + Status
                      Stack(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: profile?.avatarUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      profile!.avatarUrl!,
                                      width: 88,
                                      height: 88,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.person,
                                                size: 40,
                                                color: AppColors.primary,
                                              ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: AppColors.primary,
                                  ),
                          ),
                          if (profile != null)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: profile.isOnline
                                      ? AppColors.online
                                      : AppColors.offline,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: surfaceColor,
                                    width: 2.5,
                                  ),
                                ),
                                child: Icon(
                                  profile.isOnline ? Icons.check : Icons.remove,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        profile?.fullName ?? l10n.driver,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Status badge
                      _buildStatusBadge(profile?.status),
                      const SizedBox(height: 12),
                      // Contact info
                      if (profile?.phone.isNotEmpty == true)
                        _buildInfoChip(
                          Icons.phone_outlined,
                          profile!.phone,
                          secondaryColor,
                          textDirection: TextDirection.ltr,
                        ),
                      if (profile != null &&
                          profile.email != null &&
                          profile.email!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _buildInfoChip(
                          Icons.email_outlined,
                          profile.email!,
                          secondaryColor,
                        ),
                      ],
                      // Vehicle info
                      if (profile?.vehicleMake != null ||
                          profile?.vehicleModel != null) ...[
                        const SizedBox(height: 6),
                        _buildInfoChip(
                          Icons.directions_car_outlined,
                          [
                            profile?.vehicleMake,
                            profile?.vehicleModel,
                            if (profile?.vehicleYear != null &&
                                profile!.vehicleYear! > 0)
                              '(${profile.vehicleYear})',
                          ].where((e) => e != null).join(' '),
                          secondaryColor,
                        ),
                      ],
                      if (profile?.vehiclePlateNumber != null &&
                          profile!.vehiclePlateNumber!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _buildInfoChip(
                          Icons.badge_outlined,
                          profile.vehiclePlateNumber!,
                          secondaryColor,
                        ),
                      ],
                      if (profile?.memberSince != null &&
                          profile!.memberSince != 'N/A') ...[
                        const SizedBox(height: 6),
                        _buildInfoChip(
                          Icons.calendar_today_outlined,
                          'Joined ${profile.memberSince}',
                          secondaryColor,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Account Section
                Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        Icons.edit,
                        l10n.editProfile,
                        null,
                        AppColors.primary,
                        textColor,
                        secondaryColor,
                        borderColor,
                        true,
                        () => context.push(RouteConstants.editProfile),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Settings Section
                Container(
                  key: _tourKeys.settingsMenuKey,
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
                      Container(
                        key: _tourKeys.kbMenuKey,
                        child: _buildMenuItem(
                          Icons.help_center_outlined,
                          l10n.knowledgeBase,
                          null,
                          AppColors.success,
                          textColor,
                          secondaryColor,
                          borderColor,
                          false,
                          () => context.push(RouteConstants.knowledgeBase),
                        ),
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

                const SizedBox(height: 16),

                // Delete Account
                Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: _buildMenuItem(
                    Icons.delete_forever,
                    l10n.deleteAccount,
                    null,
                    AppColors.error,
                    AppColors.error,
                    secondaryColor,
                    borderColor,
                    true,
                    () => _showDeleteAccountDialog(context, l10n),
                  ),
                ),

                const SizedBox(height: 24),

                // Version
                Center(
                  child: Column(
                    children: [
                      Text(
                        l10n.version('1.0.5'),
                        style: TextStyle(fontSize: 12, color: secondaryColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '17 April 2026',
                        style: TextStyle(fontSize: 11, color: secondaryColor),
                      ),
                    ],
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

  Widget _buildStatusBadge(String? status) {
    if (status == null) return const SizedBox.shrink();

    Color color;
    IconData icon;
    switch (status.toUpperCase()) {
      case 'APPROVED':
        color = AppColors.success;
        icon = Icons.verified;
      case 'PENDING':
        color = AppColors.warning;
        icon = Icons.hourglass_top;
      case 'REJECTED':
        color = AppColors.error;
        icon = Icons.cancel;
      default:
        color = AppColors.info;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status[0] + status.substring(1).toLowerCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    IconData icon,
    String text,
    Color color, {
    TextDirection? textDirection,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: textDirection,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: color),
            textDirection: textDirection,
            overflow: TextOverflow.ellipsis,
          ),
        ),
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
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) => Padding(
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
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: LocaleProvider.supportedLocales
                      .map(
                        (locale) => ListTile(
                          onTap: () {
                            localeProvider.setLocale(locale);
                            Navigator.pop(ctx);
                          },
                          leading: Icon(
                            localeProvider.locale.languageCode ==
                                    locale.languageCode
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: AppColors.primary,
                          ),
                          title: Text(
                            localeProvider.getLanguageName(locale.languageCode),
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
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
              await _performLogout(context, l10n);
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

  Future<void> _performLogout(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final authProvider = context.read<AuthProvider>();
    NavigatorState? dialogNavigator;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogNavigator = Navigator.of(ctx);
        return Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(l10n.loading),
                ],
              ),
            ),
          ),
        );
      },
    );

    try {
      await authProvider.logout();
    } finally {
      if (dialogNavigator?.mounted ?? false) {
        dialogNavigator!.pop();
      }
    }
  }

  void _showDeleteAccountDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(l10n.deleteAccount)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.deleteAccountConfirm,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: AppColors.error.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.deleteDataWarning,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.error.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _confirmDeleteAccount(context, l10n);
            },
            child: Text(
              l10n.deleteAccount,
              style: const TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
              child: const Icon(
                Icons.delete_forever,
                color: AppColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(l10n.finalConfirmation)),
          ],
        ),
        content: Text(
          l10n.finalDeleteWarning,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _performDeleteAccount(context, l10n);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              l10n.deleteMyAccount,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performDeleteAccount(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(l10n.deletingAccount),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      if (context.mounted) {
        context.read<DriverProvider>().clearProfile();
      }
      if (context.mounted) {
        await context.read<AuthProvider>().deleteAccount();
      }
      if (context.mounted) {
        Navigator.pop(context);
      }
      if (context.mounted) {
        context.go(RouteConstants.phone);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.accountDeletedSuccessfully),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToDeleteAccount(e.toString())),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}
