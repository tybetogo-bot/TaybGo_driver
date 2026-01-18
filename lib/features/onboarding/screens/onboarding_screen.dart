import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _goToPhone();
    }
  }

  void _goToPhone() {
    context.read<AuthProvider>().completeOnboarding();
    context.go(RouteConstants.phone);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final l10n = AppLocalizations.of(context)!;

    final pages = [
      _Page(Icons.attach_money_rounded, l10n.onboardingTitle1, l10n.onboardingDesc1, AppColors.success),
      _Page(Icons.touch_app_rounded, l10n.onboardingTitle2, l10n.onboardingDesc2, AppColors.info),
      _Page(Icons.navigation_rounded, l10n.onboardingTitle3, l10n.onboardingDesc3, AppColors.primary),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.local_shipping, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        l10n.appName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _goToPhone,
                    child: Text(l10n.skip, style: TextStyle(color: secondaryColor)),
                  ),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: pages.length,
                itemBuilder: (context, i) {
                  final page = pages[i];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: page.color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(page.icon, size: 64, color: page.color),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          page.title,
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: textColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.description,
                          style: TextStyle(fontSize: 16, color: secondaryColor, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicators & Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? pages[i].color
                              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _next,
                      icon: Icon(
                        _currentPage == pages.length - 1 ? Icons.rocket_launch : Icons.arrow_forward,
                        size: 20,
                      ),
                      label: Text(
                        _currentPage == pages.length - 1 ? l10n.getStarted : l10n.next,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pages[_currentPage].color,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  _Page(this.icon, this.title, this.description, this.color);
}
