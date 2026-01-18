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
  final _controller = TextEditingController();
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
    _controller.dispose();
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

  Future<void> _verify() async {
    if (_controller.text.length != 6) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.verifyOtp(_controller.text);

    if (mounted && success) {
      context.go(RouteConstants.home);
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
        const SnackBar(
          content: Text('OTP sent successfully'),
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
              Row(
                children: [
                  Icon(Icons.phone_android, size: 16, color: secondaryColor),
                  const SizedBox(width: 6),
                  Text(
                    l10n.enterOtp,
                    style: TextStyle(fontSize: 14, color: secondaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.phoneNumber,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
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

              // Code input container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _controller.text.isNotEmpty ? AppColors.primary.withValues(alpha: 0.3) : borderColor,
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        letterSpacing: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: '000000',
                        hintStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
                          letterSpacing: 16,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      onChanged: (value) {
                        setState(() {});
                        if (value.length == 6) _verify();
                      },
                    ),
                    const SizedBox(height: 12),
                    // Progress indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        final filled = index < _controller.text.length;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 32,
                          height: 4,
                          decoration: BoxDecoration(
                            color: filled ? AppColors.primary : borderColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

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
                              'Resend in ${_resendSeconds}s',
                              style: TextStyle(fontSize: 14, color: secondaryColor),
                            ),
                          ],
                        ),
                      )
                    : TextButton.icon(
                        onPressed: _resendOtp,
                        icon: const Icon(Icons.refresh, size: 18, color: AppColors.primary),
                        label: const Text(
                          'Resend code',
                          style: TextStyle(
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
                      onPressed: _controller.text.length == 6 && !isLoading ? _verify : null,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.check_circle, size: 20),
                      label: const Text('Verify', style: TextStyle(fontWeight: FontWeight.w600)),
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
}
