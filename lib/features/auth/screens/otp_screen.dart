import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_otp_auth_ui/phone_otp_auth_ui.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int _resendSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _resendSeconds = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _resendOtp() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.requestOtp(widget.phoneNumber);

    if (mounted && success) {
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.otpSentSuccessfully),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted && authProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error!),
          backgroundColor: AppColors.error,
        ),
      );
      authProvider.clearError();
    }
  }

  AuthUiStrings _buildStrings(AppLocalizations l10n) {
    return AuthUiStrings(
      otpVerifyTitle: l10n.verifyOtp,
      otpCodeLabel: l10n.verifyOtp,
      verifyLabel: l10n.verify,
      changePhoneNumberLabel: l10n.enterPhoneNumber,
      enterOtpError: l10n.enterOtp,
      enterCodeSentToBuilder: (phone) => '${l10n.enterOtp} $phone',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.arrow_back, color: textColor, size: 20),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Icon
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.sms_outlined, color: AppColors.info, size: 28),
                  ),
                  const SizedBox(height: 24),

                  // OTP form from package
                  OtpVerifyForm(
                    phone: widget.phoneNumber,
                    strings: _buildStrings(l10n),
                    isLoading: authProvider.isLoading,
                    errorText: authProvider.error,
                    testOtp: authProvider.debugOtp,
                    onChangePhoneNumber: () => context.pop(),
                    onSubmit: (code) async {
                      final router = GoRouter.of(context);
                      final success = await authProvider.verifyOtp(code);

                      if (success) {
                        if (authProvider.isNewUser) {
                          router.go(RouteConstants.application);
                        } else {
                          router.go(RouteConstants.home);
                        }
                      } else if (authProvider.error != null) {
                        authProvider.clearError();
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  // Resend section
                  Center(
                    child: _resendSeconds > 0
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.timer, size: 16, color: secondaryColor),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.resendIn(_resendSeconds),
                                  style: TextStyle(fontSize: 14, color: secondaryColor),
                                ),
                              ],
                            ),
                          )
                        : TextButton.icon(
                            onPressed: _resendOtp,
                            icon: const Icon(Icons.refresh, size: 18, color: AppColors.primary),
                            label: Text(
                              l10n.resendCode,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
