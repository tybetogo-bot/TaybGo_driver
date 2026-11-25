import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/driver_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/email_utils.dart';

/// Non-dismissible gate displayed over protected driver shells whenever the
/// authenticated driver profile still lacks a normalized email address.
class MandatoryEmailGate extends StatelessWidget {
  final Widget child;

  const MandatoryEmailGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final needsEmail = context.select<DriverProvider, bool>(
      (provider) => provider.profile?.needsEmail == true,
    );

    return PopScope(
      canPop: !needsEmail,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AbsorbPointer(absorbing: needsEmail, child: child),
          if (needsEmail) ...[
            const ModalBarrier(
              dismissible: false,
              color: Color(0x8A000000),
            ),
            const Center(
              child: MandatoryEmailDialog(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Prompt card requiring existing drivers to add a valid email address before
/// continuing, with an explicit Log Out escape hatch.
class MandatoryEmailDialog extends StatefulWidget {
  const MandatoryEmailDialog({super.key});

  @override
  State<MandatoryEmailDialog> createState() => _MandatoryEmailDialogState();
}

class _MandatoryEmailDialogState extends State<MandatoryEmailDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSaving = false;
  bool _isLoggingOut = false;
  String? _serverError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitEmail() async {
    if (_isSaving || _isLoggingOut) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSaving = true;
      _serverError = null;
    });

    final l10n = AppLocalizations.of(context)!;
    final driverProvider = context.read<DriverProvider>();
    final normalized = normalizeEmail(_emailController.text);
    final success = await driverProvider.updateUserProfile(email: normalized);

    if (!mounted) return;
    setState(() {
      _isSaving = false;
      if (!success) {
        _serverError = driverProvider.error ?? l10n.failedToUpdateProfile;
      }
    });
  }

  Future<void> _logout() async {
    if (_isSaving || _isLoggingOut) return;
    setState(() {
      _isLoggingOut = true;
      _serverError = null;
    });

    try {
      await context.read<AuthProvider>().logout();
    } catch (_) {
      // AppRouter redirects once AuthProvider finishes resetting state.
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkBg : AppColors.lightSurface;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Material(
          color: surfaceColor,
          elevation: 8,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mark_email_unread_outlined,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.emailRequiredTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.emailRequiredMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    enabled: !_isSaving && !_isLoggingOut,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    textDirection: TextDirection.ltr,
                    autofillHints: const [AutofillHints.email],
                    onChanged: (_) {
                      if (_serverError != null) {
                        setState(() => _serverError = null);
                      }
                    },
                    onFieldSubmitted: (_) => _submitEmail(),
                    style: TextStyle(fontSize: 15, color: textColor),
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      hintText: l10n.enterYourEmail,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: cardBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.error,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      final normalized = normalizeEmail(value ?? '');
                      if (normalized.isEmpty) {
                        return l10n.pleaseEnterYourEmail;
                      }
                      if (!isValidNormalizedEmail(normalized)) {
                        return l10n.pleaseEnterValidEmail;
                      }
                      return null;
                    },
                  ),
                  if (_serverError != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 18,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _serverError!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSaving || _isLoggingOut
                          ? null
                          : _submitEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              l10n.saveEmail,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _isSaving || _isLoggingOut ? null : _logout,
                    icon: _isLoggingOut
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.logout, size: 18),
                    label: Text(l10n.logout),
                    style: TextButton.styleFrom(
                      foregroundColor: secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
