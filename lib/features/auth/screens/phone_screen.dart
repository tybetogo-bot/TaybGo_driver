import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';

class _Country {
  final String name;
  final String code;
  final String dialCode;
  final String flag;

  const _Country(this.name, this.code, this.dialCode, this.flag);
}

const _countries = [
  _Country('Germany', 'DE', '+49', '\u{1F1E9}\u{1F1EA}'),
  _Country('France', 'FR', '+33', '\u{1F1EB}\u{1F1F7}'),
  _Country('United Kingdom', 'GB', '+44', '\u{1F1EC}\u{1F1E7}'),
  _Country('United States', 'US', '+1', '\u{1F1FA}\u{1F1F8}'),
  _Country('Austria', 'AT', '+43', '\u{1F1E6}\u{1F1F9}'),
  _Country('Switzerland', 'CH', '+41', '\u{1F1E8}\u{1F1ED}'),
  _Country('Netherlands', 'NL', '+31', '\u{1F1F3}\u{1F1F1}'),
  _Country('Belgium', 'BE', '+32', '\u{1F1E7}\u{1F1EA}'),
  _Country('Italy', 'IT', '+39', '\u{1F1EE}\u{1F1F9}'),
  _Country('Spain', 'ES', '+34', '\u{1F1EA}\u{1F1F8}'),
  _Country('Poland', 'PL', '+48', '\u{1F1F5}\u{1F1F1}'),
  _Country('Turkey', 'TR', '+90', '\u{1F1F9}\u{1F1F7}'),
];

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _controller = TextEditingController();
  _Country _selectedCountry = _countries[0]; // Germany by default

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_controller.text.length < 6) return;

    final fullNumber = '${_selectedCountry.dialCode}${_controller.text}';
    final authProvider = context.read<AuthProvider>();

    debugPrint('[PhoneScreen] Calling requestOtp for: $fullNumber');
    final success = await authProvider.requestOtp(fullNumber);
    debugPrint(
      '[PhoneScreen] requestOtp returned: $success, error: ${authProvider.error}',
    );

    if (mounted && success) {
      debugPrint('[PhoneScreen] Navigating to OTP screen');
      context.go(RouteConstants.otp, extra: fullNumber);
    } else if (mounted && authProvider.error != null) {
      debugPrint('[PhoneScreen] Showing error snackbar: ${authProvider.error}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error!),
          backgroundColor: AppColors.error,
        ),
      );
      authProvider.clearError();
    } else {
      debugPrint('[PhoneScreen] No success and no error - unexpected state');
    }
  }

  void _showCountryPicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;

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
                    'Select Country',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _countries.length,
                itemBuilder: (context, index) {
                  final country = _countries[index];
                  final isSelected = country.code == _selectedCountry.code;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        country.flag,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    title: Text(
                      country.name,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          country.dialCode,
                          style: TextStyle(color: secondaryColor),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    onTap: () {
                      setState(() => _selectedCountry = country);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              // Logo
              Container(
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
              ),

              const SizedBox(height: 32),

              // Title
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
                      color: AppColors.info.withValues(alpha: 0.1),
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
                          'Secure',
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
                  Text(
                    'We\'ll send you a verification code',
                    style: TextStyle(fontSize: 14, color: secondaryColor),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Phone input with country code
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _controller.text.isNotEmpty
                        ? AppColors.primary
                        : borderColor,
                    width: _controller.text.isNotEmpty ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Country selector
                    GestureDetector(
                      onTap: _showCountryPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBg : AppColors.lightBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _selectedCountry.flag,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedCountry.dialCode,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: secondaryColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Phone number input
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          hintText: '123 456 7890',
                          hintStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? AppColors.darkTextHint
                                : AppColors.lightTextHint,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Continue button
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  final isLoading = authProvider.isLoading;
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _controller.text.length >= 6 && !isLoading
                          ? _continue
                          : null,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.arrow_forward, size: 20),
                      label: const Text(
                        'Continue',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: borderColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // New user link
              // Center(
              //   child: TextButton.icon(
              //     onPressed: () => context.push(RouteConstants.application),
              //     icon: const Icon(
              //       Icons.person_add_alt_1,
              //       size: 18,
              //       color: AppColors.primary,
              //     ),
              //     label: Text.rich(
              //       TextSpan(
              //         text: 'New driver? ',
              //         style: TextStyle(color: secondaryColor),
              //         children: const [
              //           TextSpan(
              //             text: 'Apply here',
              //             style: TextStyle(
              //               color: AppColors.primary,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 8),

              // Terms
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 14,
                      color: secondaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'By continuing, you agree to our Terms & Privacy',
                      style: TextStyle(fontSize: 12, color: secondaryColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
