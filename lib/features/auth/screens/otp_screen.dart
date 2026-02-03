import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
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
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _resendSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
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

  String get _otpCode => _controllers.map((c) => c.text).join();

  void _handlePaste(String pastedText) {
    // Remove any non-digit characters
    final digits = pastedText.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;

    // Fill the boxes with the pasted digits
    for (int i = 0; i < 6 && i < digits.length; i++) {
      _controllers[i].text = digits[i];
    }

    // Focus the last filled field or the next empty one
    final lastIndex = digits.length >= 6 ? 5 : digits.length;
    if (lastIndex < 6) {
      _focusNodes[lastIndex].requestFocus();
    } else {
      _focusNodes[5].unfocus();
      // Auto-verify if we have 6 digits
      if (digits.length >= 6) {
        setState(() {});
        _verify();
      }
    }
  }

  Future<void> _verify() async {
    if (_otpCode.length != 6) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.verifyOtp(_otpCode);

    if (mounted && success) {
      // Check if user needs to complete profile
      if (authProvider.isNewUser) {
        context.go(RouteConstants.application);
      } else {
        context.go(RouteConstants.home);
      }
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
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
          child: Column(
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

              // Title
              Text(
                l10n.verifyOtp,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.enterOtp,
                style: TextStyle(
                  fontSize: 15,
                  color: secondaryColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone_android, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    widget.phoneNumber,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              // Debug OTP display
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  final debugOtp = authProvider.debugOtp;
                  if (debugOtp == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.bug_report, color: AppColors.warning, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Debug OTP: $debugOtp',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // OTP Input - Individual digit boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return _buildOtpBox(
                    context,
                    index,
                    textColor,
                    surfaceColor,
                    borderColor,
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Resend
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

              const SizedBox(height: 40),

              // Verify button
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  final isLoading = authProvider.isLoading;
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _otpCode.length == 6 && !isLoading ? _verify : null,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.check_circle, size: 20),
                      label: Text(l10n.verify, style: const TextStyle(fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: borderColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(
    BuildContext context,
    int index,
    Color textColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    final isFilled = _controllers[index].text.isNotEmpty;
    final isFocused = _focusNodes[index].hasFocus;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        _focusNodes[index].requestFocus();
        // Select all text if filled so typing replaces it
        if (isFilled) {
          _controllers[index].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[index].text.length,
          );
        }
      },
      child: Container(
        width: 48,
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isFocused
                ? AppColors.primary
                : isFilled
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : borderColor.withValues(alpha: 0.4),
            width: 2,
          ),
        ),
        child: Center(
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace) {
                if (_controllers[index].text.isEmpty && index > 0) {
                  // Move to previous field on backspace if current field is empty
                  _focusNodes[index - 1].requestFocus();
                  // Select the text in the previous field
                  _controllers[index - 1].selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _controllers[index - 1].text.length,
                  );
                } else if (_controllers[index].text.isNotEmpty) {
                  // Clear current field
                  _controllers[index].clear();
                  setState(() {});
                }
              }
            },
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              autofocus: index == 0,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: '·',
                hintStyle: TextStyle(
                  fontSize: 24,
                  color: borderColor.withValues(alpha: 0.5),
                ),
                contentPadding: EdgeInsets.zero,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                // Handle paste - if more than 1 character, treat as paste
                if (value.length > 1) {
                  _handlePaste(value);
                  return;
                }

                setState(() {});
                if (value.isNotEmpty) {
                  // Move to next field
                  if (index < 5) {
                    _focusNodes[index + 1].requestFocus();
                  } else {
                    // Last field - verify
                    _focusNodes[index].unfocus();
                    if (_otpCode.length == 6) {
                      _verify();
                    }
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
