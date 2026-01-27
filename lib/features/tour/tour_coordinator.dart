import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../core/constants/route_constants.dart';
import '../../core/providers/tour_provider.dart';
import '../../core/models/tour_models.dart';
import 'tour_keys.dart';
import 'widgets/tour_content_widget.dart';
import 'widgets/tour_completion_dialog.dart';

/// Coordinates the entire tour flow across different screens
class TourCoordinator {
  final BuildContext context;
  final TourProvider tourProvider;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  TutorialCoachMark? _tutorialCoachMark;
  List<TargetFocus> _targets = [];

  TourCoordinator({
    required this.context,
    required this.tourProvider,
    this.onComplete,
    this.onSkip,
  });

  /// Start the tour from a specific stage
  Future<void> startTour({TourStage stage = TourStage.home}) async {
    tourProvider.setStage(stage);
    await _showTourStage(stage);
  }

  /// Show tour for a specific stage
  Future<void> _showTourStage(TourStage stage) async {
    switch (stage) {
      case TourStage.home:
        await _showHomeStage();
        break;
      case TourStage.orderAcceptance:
        await _showOrderAcceptanceStage();
        break;
      case TourStage.activeOrder:
        await _showActiveOrderStage();
        break;
      case TourStage.orders:
        await _showOrdersStage();
        break;
      case TourStage.earnings:
        await _showEarningsStage();
        break;
      case TourStage.profile:
        await _showProfileStage();
        break;
    }
  }

  /// Home screen tour stage
  Future<void> _showHomeStage() async {
    _targets = _createHomeTargets();
    if (_targets.isEmpty) return;

    _createTutorial(
      targets: _targets,
      stage: TourStage.home,
      onFinish: () => _completeStage(TourStage.home),
      onSkip: _handleSkip,
    );

    _tutorialCoachMark?.show(context: context);
  }

  /// Order acceptance stage (when mock order appears)
  Future<void> _showOrderAcceptanceStage() async {
    // Wait a bit for UI to update with mock order
    await Future.delayed(const Duration(milliseconds: 500));

    _targets = _createOrderAcceptanceTargets();
    if (_targets.isEmpty) return;

    _createTutorial(
      targets: _targets,
      stage: TourStage.orderAcceptance,
      onFinish: () => _completeStage(TourStage.orderAcceptance),
      onSkip: _handleSkip,
    );

    _tutorialCoachMark?.show(context: context);
  }

  /// Active order management stage
  Future<void> _showActiveOrderStage() async {
    _targets = _createActiveOrderTargets();
    if (_targets.isEmpty) return;

    _createTutorial(
      targets: _targets,
      stage: TourStage.activeOrder,
      onFinish: () => _completeStage(TourStage.activeOrder),
      onSkip: _handleSkip,
    );

    _tutorialCoachMark?.show(context: context);
  }

  /// Orders tab stage
  Future<void> _showOrdersStage() async {
    _targets = _createOrdersTargets();
    if (_targets.isEmpty) return;

    _createTutorial(
      targets: _targets,
      stage: TourStage.orders,
      onFinish: () => _completeStage(TourStage.orders),
      onSkip: _handleSkip,
    );

    _tutorialCoachMark?.show(context: context);
  }

  /// Earnings tab stage
  Future<void> _showEarningsStage() async {
    _targets = _createEarningsTargets();
    if (_targets.isEmpty) return;

    _createTutorial(
      targets: _targets,
      stage: TourStage.earnings,
      onFinish: () => _completeStage(TourStage.earnings),
      onSkip: _handleSkip,
    );

    _tutorialCoachMark?.show(context: context);
  }

  /// Profile tab stage
  Future<void> _showProfileStage() async {
    _targets = _createProfileTargets();
    if (_targets.isEmpty) return;

    _createTutorial(
      targets: _targets,
      stage: TourStage.profile,
      onFinish: () => _completeTour(),
      onSkip: _handleSkip,
    );

    _tutorialCoachMark?.show(context: context);
  }

  /// Create tutorial coach mark instance
  void _createTutorial({
    required List<TargetFocus> targets,
    required TourStage stage,
    required VoidCallback onFinish,
    required VoidCallback onSkip,
  }) {
    _tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.85,
      onFinish: onFinish,
      onSkip: () {
        onSkip();
        return true;
      },
      onClickTarget: (target) {
        // Handle target click if needed
      },
      onClickOverlay: (target) {
        // Move to next step on overlay click
        _tutorialCoachMark?.next();
      },
    );
  }

  /// Complete a stage and move to next
  void _completeStage(TourStage completedStage) {
    tourProvider.nextStage();

    // Move to next stage
    final stages = TourStage.values;
    final currentIndex = stages.indexOf(completedStage);

    if (currentIndex < stages.length - 1) {
      final nextStage = stages[currentIndex + 1];

      // Special handling for stage transitions
      if (nextStage == TourStage.orderAcceptance) {
        // Inject mock order before showing acceptance stage
        tourProvider.injectMockOrder();
        Future.delayed(const Duration(milliseconds: 800), () {
          if (context.mounted) {
            _showTourStage(nextStage);
          }
        });
      } else {
        // Show next stage immediately
        _showTourStage(nextStage);
      }
    }
  }

  /// Complete the entire tour
  void _completeTour() {
    tourProvider.completeTour();

    // Show completion dialog
    TourCompletionDialog.show(
      context,
      onClose: () {
        onComplete?.call();
      },
      onViewKnowledgeBase: () {
        // Navigate to knowledge base
        if (context.mounted) {
          context.push(RouteConstants.knowledgeBase);
        }
      },
    );
  }

  /// Handle tour skip
  void _handleSkip() {
    tourProvider.skipTour();
    tourProvider.clearMockOrder();
    onSkip?.call();
  }

  /// Dispose resources
  void dispose() {
    _tutorialCoachMark = null;
  }

  // ========== Target Creation Methods ==========
  // These will be populated with actual GlobalKey targets when integrating with screens

  List<TargetFocus> _createHomeTargets() {
    final targets = <TargetFocus>[];
    final keys = TourKeys.instance;

    // Target 1: Verification Banner
    if (keys.verificationBannerKey.currentContext != null) {
      targets.add(
        TargetFocus(
          identify: "verification_banner",
          keyTarget: keys.verificationBannerKey,
          contents: [
            _buildTargetContent(
              title: "Account Under Review",
              description: "Your account is being verified. You can explore the app while waiting for approval.",
              step: 1,
              totalSteps: 3,
            ),
          ],
        ),
      );
    }

    // Target 2: Online Toggle
    if (keys.onlineToggleKey.currentContext != null) {
      targets.add(
        TargetFocus(
          identify: "online_toggle",
          keyTarget: keys.onlineToggleKey,
          contents: [
            _buildTargetContent(
              title: "Go Online to Receive Orders",
              description: "Toggle this switch when you're ready to accept deliveries. You can go offline anytime.",
              step: 2,
              totalSteps: 3,
            ),
          ],
        ),
      );
    }

    // Target 3: Stats Card
    if (keys.statsCardKey.currentContext != null) {
      targets.add(
        TargetFocus(
          identify: "stats_card",
          keyTarget: keys.statsCardKey,
          contents: [
            _buildTargetContent(
              title: "Your Daily Stats",
              description: "Track your orders, earnings, and rating here. Stats update in real-time.",
              step: 3,
              totalSteps: 3,
              isLast: true,
            ),
          ],
        ),
      );
    }

    return targets;
  }

  List<TargetFocus> _createOrderAcceptanceTargets() {
    final targets = <TargetFocus>[];
    final keys = TourKeys.instance;

    // Target: New Order Card
    if (keys.newOrderCardKey.currentContext != null) {
      targets.add(
        TargetFocus(
          identify: "new_order_card",
          keyTarget: keys.newOrderCardKey,
          contents: [
            _buildTargetContent(
              title: "New Order Received!",
              description: "This is how new orders appear. Review the pickup location, dropoff, distance, and payment. Tap Accept to start the delivery.",
              step: 1,
              totalSteps: 1,
              isLast: true,
            ),
          ],
        ),
      );
    }

    return targets;
  }

  List<TargetFocus> _createActiveOrderTargets() {
    final targets = <TargetFocus>[];
    // Active order management will be shown in context when order is active
    // For now, skip this stage as it requires an active order state
    return targets;
  }

  List<TargetFocus> _createOrdersTargets() {
    final targets = <TargetFocus>[];
    final keys = TourKeys.instance;

    // Target: Tab Bar
    if (keys.tabBarKey.currentContext != null) {
      targets.add(
        TargetFocus(
          identify: "orders_tab_bar",
          keyTarget: keys.tabBarKey,
          contents: [
            _buildTargetContent(
              title: "Orders Tab",
              description: "Switch between Current Orders and Order History. Your completed deliveries appear in the history tab.",
              step: 1,
              totalSteps: 1,
              isLast: true,
            ),
          ],
        ),
      );
    }

    return targets;
  }

  List<TargetFocus> _createEarningsTargets() {
    final targets = <TargetFocus>[];
    final keys = TourKeys.instance;

    // Target 1: Total Earnings
    if (keys.totalEarningsKey.currentContext != null) {
      targets.add(
        TargetFocus(
          identify: "total_earnings",
          keyTarget: keys.totalEarningsKey,
          contents: [
            _buildTargetContent(
              title: "Your Total Earnings",
              description: "Track all your earnings here. This includes base pay, tips, and bonuses.",
              step: 1,
              totalSteps: 2,
            ),
          ],
        ),
      );
    }

    // Target 2: Stats Grid
    if (keys.statsGridKey.currentContext != null) {
      targets.add(
        TargetFocus(
          identify: "earnings_stats",
          keyTarget: keys.statsGridKey,
          contents: [
            _buildTargetContent(
              title: "Earnings Breakdown",
              description: "See your total orders and average earnings per order. Use this to track your performance.",
              step: 2,
              totalSteps: 2,
              isLast: true,
            ),
          ],
        ),
      );
    }

    return targets;
  }

  List<TargetFocus> _createProfileTargets() {
    final targets = <TargetFocus>[];
    final keys = TourKeys.instance;

    // Target 1: Settings Menu
    if (keys.settingsMenuKey.currentContext != null) {
      targets.add(
        TargetFocus(
          identify: "settings_menu",
          keyTarget: keys.settingsMenuKey,
          contents: [
            _buildTargetContent(
              title: "App Settings",
              description: "Change your language, theme, and access the Knowledge Base for help anytime.",
              step: 1,
              totalSteps: 2,
            ),
          ],
        ),
      );
    }

    // Target 2: Knowledge Base Menu
    if (keys.kbMenuKey.currentContext != null) {
      targets.add(
        TargetFocus(
          identify: "kb_menu",
          keyTarget: keys.kbMenuKey,
          contents: [
            _buildTargetContent(
              title: "Knowledge Base",
              description: "Need help? Browse step-by-step guides, tips, and answers to common questions here.",
              step: 2,
              totalSteps: 2,
              isLast: true,
            ),
          ],
        ),
      );
    }

    return targets;
  }

  /// Build target content widget
  /// This will be used when populating target creation methods
  TargetContent _buildTargetContent({
    required String title,
    required String description,
    required int step,
    required int totalSteps,
    bool isLast = false,
  }) {
    return TargetContent(
      align: ContentAlign.bottom,
      builder: (context, controller) {
        return TourContentWidget(
          title: title,
          description: description,
          currentStep: step,
          totalSteps: totalSteps,
          onPrevious: step > 1
              ? () {
                  controller.previous();
                }
              : null,
          onNext: () {
            if (isLast) {
              controller.skip();
            } else {
              controller.next();
            }
          },
          onSkip: () {
            controller.skip();
          },
          showPrevious: step > 1,
          isLastStep: isLast,
        );
      },
    );
  }
}
