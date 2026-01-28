import 'package:flutter/material.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

/// Tour step tooltip rendered inside TutorialCoachMark's unconstrained overlay.
///
/// Rules for unconstrained overlay:
/// - SizedBox with explicit width at root (from MediaQuery)
/// - No Expanded, Spacer, Flexible, or CrossAxisAlignment.stretch
/// - All Rows use mainAxisSize: MainAxisSize.min
class TourContentWidget extends StatelessWidget {
  final String title;
  final String description;
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool showPrevious;
  final bool isLastStep;

  const TourContentWidget({
    super.key,
    required this.title,
    required this.description,
    required this.currentStep,
    required this.totalSteps,
    this.onPrevious,
    required this.onNext,
    required this.onSkip,
    this.showPrevious = true,
    this.isLastStep = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.white;
    final secondaryColor = Colors.white70;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth - 32,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + step
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$currentStep/$totalSteps',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Description
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: secondaryColor,
              ),
            ),
            const SizedBox(height: 12),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(1.5),
              child: SizedBox(
                height: 3,
                child: LinearProgressIndicator(
                  value: totalSteps > 0 ? currentStep / totalSteps : 0.0,
                  backgroundColor: Colors.white12,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 3,
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Buttons
            Builder(builder: (ctx) {
              final l10n = AppLocalizations.of(ctx)!;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextBtn(l10n.tourSkipBtn, onSkip, Colors.white54),
                  const SizedBox(width: 10),
                  if (showPrevious && onPrevious != null) ...[
                    _buildBtn(l10n.tourBackBtn, Icons.arrow_back_ios, onPrevious!,
                        filled: false),
                    const SizedBox(width: 8),
                  ],
                  _buildBtn(
                    isLastStep ? l10n.tourDoneBtn : l10n.tourNextBtn,
                    isLastStep ? Icons.check : Icons.arrow_forward_ios,
                    onNext,
                    filled: true,
                    iconAfter: true,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTextBtn(String label, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildBtn(
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool filled = true,
    bool iconAfter = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!iconAfter)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child:
                    Icon(icon, size: 11, color: filled ? Colors.white : Colors.white60),
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: filled ? Colors.white : Colors.white60,
              ),
            ),
            if (iconAfter)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child:
                    Icon(icon, size: 11, color: filled ? Colors.white : Colors.white60),
              ),
          ],
        ),
      ),
    );
  }
}
