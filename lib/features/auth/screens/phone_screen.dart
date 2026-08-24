import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_otp_auth_ui/phone_otp_auth_ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/release_info.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/public_config_provider.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _forcePasswordMode = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _showLanguagePicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final localeProvider = context.read<LocaleProvider>();
    final currentLocale = localeProvider.locale.languageCode;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.language,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Select Language',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            ...LocaleProvider.supportedLocales.map((locale) {
              final isSelected = locale.languageCode == currentLocale;
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getLanguageFlag(locale.languageCode),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                title: Text(
                  localeProvider.getLanguageName(locale.languageCode),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: textColor,
                  ),
                ),
                trailing: isSelected
                    ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    : null,
                onTap: () {
                  localeProvider.setLocale(locale);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getLanguageFlag(String code) {
    switch (code) {
      case 'en':
        return '🇬🇧';
      case 'de':
        return '🇩🇪';
      case 'fr':
        return '🇫🇷';
      case 'ar':
        return '🇸🇦';
      default:
        return '🌐';
    }
  }

  AuthUiStrings _buildStrings(AppLocalizations l10n, {required bool useOtp}) {
    return AuthUiStrings(
      phoneSignInTitle: l10n.enterPhoneNumber,
      phoneSignInSubtitle: useOtp
          ? l10n.wellSendVerificationCode
          : l10n.passwordRequiredForDriver,
      searchCountryHint: l10n.searchCountry,
      phoneNumberLabel: l10n.enterPhoneNumber,
      sendOtpLabel: useOtp ? l10n.continueText : l10n.signIn,
      enterPhoneError: l10n.enterPhoneNumber,
    );
  }

  Uri _resolvePublicUrl(String value) {
    final uri = Uri.parse(value);
    return uri.hasScheme ? uri : Uri.parse(AppConfig.baseUrl).resolveUri(uri);
  }

  Future<void> _openPublicUrl(String value) async {
    final opened = await launchUrl(
      _resolvePublicUrl(value),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.couldNotOpenLink)),
      );
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
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final l10n = AppLocalizations.of(context)!;
    final publicConfigProvider = context.watch<PublicConfigProvider>();
    final config = publicConfigProvider.config;
    final useOtp =
        !_forcePasswordMode &&
        (config?.usesOtpFor(AuthProvider.driverTargetRole) ?? false);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Language picker button
                      Align(
                        alignment: Alignment.topRight,
                        child: Consumer<LocaleProvider>(
                          builder: (context, localeProvider, _) {
                            return InkWell(
                              onTap: _showLanguagePicker,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _getLanguageFlag(
                                        localeProvider.locale.languageCode,
                                      ),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      localeProvider.getLanguageName(
                                        localeProvider.locale.languageCode,
                                      ),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: secondaryColor,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const Spacer(),

                      // Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          'assets/icons/TaybGo_green.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.local_shipping,
                                color: AppColors.primary,
                                size: 32,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Phone sign-in form from package
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          final errorText = authProvider.localizedError(l10n);

                          return PhoneSignInForm(
                            strings: _buildStrings(l10n, useOtp: useOtp),
                            isLoading:
                                authProvider.isLoading ||
                                publicConfigProvider.isLoading,
                            errorText: errorText,
                            initialCountry: Country.all.firstWhere(
                              (c) => c.code == 'AT',
                              orElse: () => Country.defaultCountry,
                            ),
                            autofocus: false,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.enterPhoneNumber,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.info.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.verified_user,
                                            size: 14,
                                            color: AppColors.info,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            l10n.secure,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.info,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        useOtp
                                            ? l10n.wellSendVerificationCode
                                            : l10n.passwordRequiredForDriver,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: secondaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (publicConfigProvider.isLoading)
                                  _ConfigStatusBanner(
                                    message: l10n.checkingSignInMethod,
                                    isLoading: true,
                                  )
                                else if (publicConfigProvider.hasError)
                                  _ConfigStatusBanner(
                                    message: l10n.configFallback,
                                    onRetry: publicConfigProvider.refresh,
                                  ),
                              ],
                            ),
                            additionalFields: useOtp
                                ? null
                                : TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    enabled: !authProvider.isLoading,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      labelText: l10n.password,
                                      hintText: l10n.enterPassword,
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                      ),
                                      suffixIcon: IconButton(
                                        tooltip: _obscurePassword
                                            ? 'Show'
                                            : 'Hide',
                                        onPressed: () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        ),
                                      ),
                                    ),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                        ? l10n.enterPassword
                                        : null,
                                  ),
                            onSubmit: (phoneValue) async {
                              final fullNumber = phoneValue.fullNumber;
                              final navigator = GoRouter.of(context);
                              final success = useOtp
                                  ? await authProvider.requestOtp(fullNumber)
                                  : await authProvider.loginWithPassword(
                                      fullNumber,
                                      _passwordController.text,
                                    );
                              final updatedErrorText = authProvider
                                  .localizedError(l10n);
                              debugPrint(
                                '[PhoneScreen] requestOtp returned: $success, error: $updatedErrorText',
                              );

                              if (success) {
                                if (useOtp) {
                                  debugPrint(
                                    '[PhoneScreen] Navigating to OTP screen',
                                  );
                                  navigator.push(
                                    RouteConstants.otp,
                                    extra: fullNumber,
                                  );
                                }
                              } else if (authProvider.errorCode ==
                                  AuthErrorCode.otpDisabledForRole) {
                                setState(() => _forcePasswordMode = true);
                                await publicConfigProvider.refresh();
                              } else {
                                debugPrint(
                                  '[PhoneScreen] requestOtp failed: $updatedErrorText',
                                );
                              }
                            },
                          );
                        },
                      ),

                      const Spacer(flex: 2),

                      const SizedBox(height: 8),

                      // Terms
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              size: 14,
                              color: secondaryColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${l10n.byConsentTerms} ',
                              style: TextStyle(
                                fontSize: 12,
                                color: secondaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            _LegalLink(
                              label: l10n.termsOfService,
                              onTap: () => _openPublicUrl(
                                config?.termsUrl ?? '/terms-and-conditions/',
                              ),
                            ),
                            Text(
                              ' · ',
                              style: TextStyle(color: secondaryColor),
                            ),
                            _LegalLink(
                              label: l10n.privacyPolicy,
                              onTap: () => _openPublicUrl(
                                config?.privacyUrl ?? '/privacy-policy/',
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // App version / release date (subtle)
                      Center(
                        child: Text(
                          'v${ReleaseInfo.version} · ${ReleaseInfo.releaseDate}',
                          style: TextStyle(
                            fontSize: 11,
                            color: secondaryColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfigStatusBanner extends StatelessWidget {
  const _ConfigStatusBanner({
    required this.message,
    this.isLoading = false,
    this.onRetry,
  });

  final String message;
  final bool isLoading;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (isLoading)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: color),
            )
          else
            Icon(Icons.cloud_off_outlined, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(fontSize: 12))),
          if (onRetry != null)
            IconButton(
              tooltip: AppLocalizations.of(context)!.retry,
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
            ),
        ],
      ),
    );
  }
}

class _LegalLink extends StatelessWidget {
  const _LegalLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
