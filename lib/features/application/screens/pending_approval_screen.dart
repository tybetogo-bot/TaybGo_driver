import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Status icon
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.hourglass_top_rounded, size: 64, color: AppColors.warning),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                l10n.applicationSubmitted,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: textColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.applicationPending,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.warning),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Description
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.info.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.pendingApprovalMessage,
                            style: TextStyle(fontSize: 14, color: secondaryColor, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // What happens next
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.checklist, size: 18, color: secondaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'What happens next',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildStep('1', 'We review your application', AppColors.success, secondaryColor),
                    const SizedBox(height: 12),
                    _buildStep('2', 'You get notified when approved', AppColors.info, secondaryColor),
                    const SizedBox(height: 12),
                    _buildStep('3', 'Start earning with deliveries', AppColors.primary, secondaryColor),
                  ],
                ),
              ),

              const Spacer(),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => context.go(RouteConstants.home),
                  icon: const Icon(Icons.home_outlined, size: 20),
                  label: Text(l10n.next, style: const TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.support_agent, size: 18, color: AppColors.primary),
                label: Text(l10n.contactUs, style: const TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text, Color color, Color secondaryColor) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 14, color: secondaryColor)),
      ],
    );
  }
}
