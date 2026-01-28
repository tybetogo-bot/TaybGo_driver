import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../core/constants/route_constants.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/tour_provider.dart';
import '../../core/providers/order_provider.dart';
import '../../core/models/tour_models.dart';
import '../../core/mock/tour_mock_data.dart';
import 'tour_keys.dart';
import 'widgets/tour_content_widget.dart';
import 'widgets/tour_completion_dialog.dart';

/// Coordinates the entire tour flow across different screens
class TourCoordinator {
  BuildContext context;
  final TourProvider tourProvider;
  final OrderProvider? orderProvider;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  TutorialCoachMark? _tutorialCoachMark;
  List<TargetFocus> _targets = [];
  bool _isShowingTour = false;
  bool _isDisposing = false;

  TourCoordinator({
    required this.context,
    required this.tourProvider,
    this.orderProvider,
    this.onComplete,
    this.onSkip,
  });

  /// Update the context (needed when navigating to different screens)
  void updateContext(BuildContext newContext) {
    context = newContext;
  }

  /// Start the tour from a specific stage
  Future<void> startTour({TourStage stage = TourStage.home}) async {
    debugPrint('[Tour] startTour called, stage=$stage, isShowingTour=$_isShowingTour');
    tourProvider.setStage(stage);
    await _showTourStage(stage);
  }

  /// Show tour for the current stage (called by screens when they're ready)
  Future<void> showCurrentStage() async {
    if (!tourProvider.isTourActive || _isShowingTour) return;
    await _showTourStage(tourProvider.currentStage);
  }

  /// Show tour for a specific stage
  Future<void> _showTourStage(TourStage stage) async {
    debugPrint('[Tour] _showTourStage called, stage=$stage, _isShowingTour=$_isShowingTour, _isDisposing=$_isDisposing');
    if (_isShowingTour) {
      debugPrint('[Tour] SKIPPED — already showing tour');
      return;
    }

    switch (stage) {
      case TourStage.home:
        await _showHomeStage();
        break;
      case TourStage.orderAcceptance:
        await _showOrderAcceptanceStage();
        break;
      case TourStage.activeOrder:
        // Directly inject mock order as active (bypasses countdown timer)
        // so the Orders screen will show it.
        final mock = tourProvider.mockOrder;
        debugPrint('[Tour] activeOrder stage: mockOrder=${mock?.id}, orderProvider=$orderProvider');
        if (mock != null) {
          orderProvider?.clearMockOrder(); // clear pending first
          orderProvider?.injectMockActiveOrder(mock);
          debugPrint('[Tour] Injected mock as activeOrder. activeOrder=${orderProvider?.activeOrder?.id}');
        } else {
          debugPrint('[Tour] WARNING: No mock order found in tourProvider!');
        }
        _completeStage(TourStage.activeOrder);
        break;
      case TourStage.orderDetail:
        await _showOrderDetailStage();
        break;
      case TourStage.ongoingTrip:
        await _showOngoingTripStage();
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
    debugPrint('[Tour] _showHomeStage: waiting 300ms...');
    await Future.delayed(const Duration(milliseconds: 300));

    _targets = _createHomeTargets();
    debugPrint('[Tour] _showHomeStage: ${_targets.length} targets found');
    if (_targets.isEmpty) {
      debugPrint('[Tour] _showHomeStage: NO targets, skipping to next stage');
      _completeStage(TourStage.home);
      return;
    }

    _isShowingTour = true;
    _createTutorial(
      targets: _targets,
      stage: TourStage.home,
      onFinish: () {
        debugPrint('[Tour] Home stage onFinish');
        _isShowingTour = false;
        _completeStage(TourStage.home);
      },
      onSkip: () {
        debugPrint('[Tour] Home stage onSkip');
        _isShowingTour = false;
        _handleSkip();
      },
    );

    debugPrint('[Tour] _showHomeStage: context.mounted=${context.mounted}, showing coach mark');
    if (context.mounted) {
      _tutorialCoachMark?.show(context: context);
    }
  }

  /// Order acceptance stage (when mock order appears)
  Future<void> _showOrderAcceptanceStage() async {
    debugPrint('[Tour] _showOrderAcceptanceStage: waiting 600ms...');
    await Future.delayed(const Duration(milliseconds: 600));

    _targets = _createOrderAcceptanceTargets();
    debugPrint('[Tour] _showOrderAcceptanceStage: ${_targets.length} targets found');
    debugPrint('[Tour]   newOrderCardKey.currentContext=${TourKeys.instance.newOrderCardKey.currentContext != null}');
    debugPrint('[Tour]   pendingOrder=${orderProvider?.pendingOrder?.id}');
    if (_targets.isEmpty) {
      debugPrint('[Tour] _showOrderAcceptanceStage: NO targets, skipping');
      _completeStage(TourStage.orderAcceptance);
      return;
    }

    _isShowingTour = true;
    _createTutorial(
      targets: _targets,
      stage: TourStage.orderAcceptance,
      onFinish: () {
        _isShowingTour = false;
        _completeStage(TourStage.orderAcceptance);
      },
      onSkip: () {
        _isShowingTour = false;
        _handleSkip();
      },
    );

    if (context.mounted) {
      _tutorialCoachMark?.show(context: context);
    }
  }

  /// Order detail screen stage (pushed route)
  Future<void> _showOrderDetailStage() async {
    debugPrint('[Tour] _showOrderDetailStage: waiting 600ms...');
    await Future.delayed(const Duration(milliseconds: 600));

    _targets = _createOrderDetailTargets();
    debugPrint('[Tour] _showOrderDetailStage: ${_targets.length} targets found');
    if (_targets.isEmpty) {
      debugPrint('[Tour] _showOrderDetailStage: NO targets, skipping');
      _completeStage(TourStage.orderDetail);
      return;
    }

    _isShowingTour = true;
    _createTutorial(
      targets: _targets,
      stage: TourStage.orderDetail,
      onFinish: () {
        _isShowingTour = false;
        _completeStage(TourStage.orderDetail);
      },
      onSkip: () {
        _isShowingTour = false;
        _handleSkip();
      },
    );

    if (context.mounted) {
      _tutorialCoachMark?.show(context: context);
    }
  }

  /// Ongoing trip / navigation screen stage (pushed route)
  Future<void> _showOngoingTripStage() async {
    debugPrint('[Tour] _showOngoingTripStage: waiting 600ms...');
    await Future.delayed(const Duration(milliseconds: 600));

    _targets = _createNavigationTargets();
    debugPrint('[Tour] _showOngoingTripStage: ${_targets.length} targets found');
    if (_targets.isEmpty) {
      debugPrint('[Tour] _showOngoingTripStage: NO targets, skipping');
      _completeStage(TourStage.ongoingTrip);
      return;
    }

    _isShowingTour = true;
    _createTutorial(
      targets: _targets,
      stage: TourStage.ongoingTrip,
      onFinish: () {
        _isShowingTour = false;
        _completeStage(TourStage.ongoingTrip);
      },
      onSkip: () {
        _isShowingTour = false;
        _handleSkip();
      },
    );

    if (context.mounted) {
      _tutorialCoachMark?.show(context: context);
    }
  }

  /// Orders tab stage
  Future<void> _showOrdersStage() async {
    debugPrint('[Tour] _showOrdersStage: waiting 400ms...');
    await Future.delayed(const Duration(milliseconds: 400));

    debugPrint('[Tour] _showOrdersStage: activeOrder=${orderProvider?.activeOrder?.id}');
    debugPrint('[Tour]   tabBarKey.currentContext=${TourKeys.instance.tabBarKey.currentContext != null}');
    _targets = _createOrdersTargets();
    debugPrint('[Tour] _showOrdersStage: ${_targets.length} targets found');
    if (_targets.isEmpty) {
      debugPrint('[Tour] _showOrdersStage: NO targets, skipping');
      _completeStage(TourStage.orders);
      return;
    }

    _isShowingTour = true;
    _createTutorial(
      targets: _targets,
      stage: TourStage.orders,
      onFinish: () {
        _isShowingTour = false;
        _completeStage(TourStage.orders);
      },
      onSkip: () {
        _isShowingTour = false;
        _handleSkip();
      },
    );

    if (context.mounted) {
      _tutorialCoachMark?.show(context: context);
    }
  }

  /// Earnings tab stage
  Future<void> _showEarningsStage() async {
    // Wait for screen to build
    await Future.delayed(const Duration(milliseconds: 400));

    _targets = _createEarningsTargets();
    if (_targets.isEmpty) {
      _completeStage(TourStage.earnings);
      return;
    }

    _isShowingTour = true;
    _createTutorial(
      targets: _targets,
      stage: TourStage.earnings,
      onFinish: () {
        _isShowingTour = false;
        _completeStage(TourStage.earnings);
      },
      onSkip: () {
        _isShowingTour = false;
        _handleSkip();
      },
    );

    if (context.mounted) {
      _tutorialCoachMark?.show(context: context);
    }
  }

  /// Profile tab stage
  Future<void> _showProfileStage() async {
    // Wait for screen to build
    await Future.delayed(const Duration(milliseconds: 400));

    _targets = _createProfileTargets();
    if (_targets.isEmpty) {
      _completeTour();
      return;
    }

    _isShowingTour = true;
    _createTutorial(
      targets: _targets,
      stage: TourStage.profile,
      onFinish: () {
        _isShowingTour = false;
        _completeTour();
      },
      onSkip: () {
        _isShowingTour = false;
        _handleSkip();
      },
    );

    if (context.mounted) {
      _tutorialCoachMark?.show(context: context);
    }
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
      hideSkip: true, // We use our own skip button in TourContentWidget
      onFinish: onFinish,
      onSkip: () {
        onSkip();
        return true;
      },
      onClickTarget: (target) {
        // Move to next on target click
      },
      onClickOverlay: (target) {
        // Move to next step on overlay click
        _tutorialCoachMark?.next();
      },
    );
  }

  /// Complete a stage and move to next
  void _completeStage(TourStage completedStage) {
    debugPrint('[Tour] _completeStage: completed=$completedStage, _isDisposing=$_isDisposing');
    if (_isDisposing) return;
    final stages = TourStage.values;
    final currentIndex = stages.indexOf(completedStage);

    if (currentIndex < stages.length - 1) {
      final nextStage = stages[currentIndex + 1];
      debugPrint('[Tour] _completeStage: next=$nextStage');
      tourProvider.setStage(nextStage);

      // Check if we need to navigate to a different tab
      final currentTab = tourProvider.getTabIndexForStage(completedStage);
      final nextTab = tourProvider.getTabIndexForStage(nextStage);
      debugPrint('[Tour] _completeStage: currentTab=$currentTab, nextTab=$nextTab');

      if (nextStage == TourStage.orderAcceptance) {
        // Special handling: inject mock order before showing acceptance stage
        final mockOrder = TourMockData.createMockOrder();
        tourProvider.setMockOrder(mockOrder);
        orderProvider?.injectMockOrder(mockOrder);
        debugPrint('[Tour] Injected mock pending order: ${mockOrder.id}');
        Future.delayed(const Duration(milliseconds: 800), () {
          debugPrint('[Tour] orderAcceptance delayed callback: mounted=${context.mounted}');
          if (context.mounted) {
            _showTourStage(nextStage);
          }
        });
      } else if (nextStage == TourStage.orderDetail) {
        // Push to order detail screen for the mock order
        final mockId = tourProvider.mockOrder?.id ?? orderProvider?.activeOrder?.id;
        debugPrint('[Tour] Pushing to order detail: mockId=$mockId');
        if (mockId != null && context.mounted) {
          context.push(RouteConstants.orderDetailPath(mockId));
          Future.delayed(const Duration(milliseconds: 800), () {
            if (context.mounted && tourProvider.isTourActive) {
              _showTourStage(nextStage);
            }
          });
        } else {
          _showTourStage(nextStage); // will skip due to no targets
        }
      } else if (nextStage == TourStage.ongoingTrip) {
        // Pop order detail, then push navigation screen
        final mockId = tourProvider.mockOrder?.id ?? orderProvider?.activeOrder?.id;
        debugPrint('[Tour] Transitioning to navigation: mockId=$mockId');
        if (mockId != null && context.mounted) {
          // Pop order detail first
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          Future.delayed(const Duration(milliseconds: 400), () {
            if (context.mounted && tourProvider.isTourActive) {
              context.push(RouteConstants.navigationPath(mockId));
              Future.delayed(const Duration(milliseconds: 800), () {
                if (context.mounted && tourProvider.isTourActive) {
                  _showTourStage(nextStage);
                }
              });
            }
          });
        } else {
          _showTourStage(nextStage);
        }
      } else if (nextTab == -1) {
        // Pushed route stage that needs special handling
        debugPrint('[Tour] Unknown pushed route stage: $nextStage');
        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) {
            _showTourStage(nextStage);
          }
        });
      } else if (completedStage == TourStage.ongoingTrip) {
        // Pop navigation screen, then navigate to the next tab
        debugPrint('[Tour] Popping navigation, then navigating to tab $nextTab');
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        Future.delayed(const Duration(milliseconds: 400), () {
          if (context.mounted && tourProvider.isTourActive) {
            tourProvider.navigateToTab(nextTab);
            Future.delayed(const Duration(milliseconds: 800), () {
              if (context.mounted && tourProvider.isTourActive) {
                _showTourStage(nextStage);
              }
            });
          }
        });
      } else if (currentTab != nextTab) {
        // Navigate to the new tab first, then show the tour
        debugPrint('[Tour] Navigating to tab $nextTab for stage $nextStage');
        tourProvider.navigateToTab(nextTab);
        Future.delayed(const Duration(milliseconds: 800), () {
          debugPrint('[Tour] tab-nav delayed callback: mounted=${context.mounted}, isTourActive=${tourProvider.isTourActive}');
          if (context.mounted && tourProvider.isTourActive) {
            _showTourStage(nextStage);
          }
        });
      } else {
        // Same tab, show next stage immediately
        debugPrint('[Tour] Same tab, delayed 300ms for $nextStage');
        Future.delayed(const Duration(milliseconds: 300), () {
          debugPrint('[Tour] same-tab delayed callback: mounted=${context.mounted}');
          if (context.mounted) {
            _showTourStage(nextStage);
          }
        });
      }
    } else {
      debugPrint('[Tour] Last stage completed, finishing tour');
      _completeTour();
    }
  }

  /// Complete the entire tour
  void _completeTour() {
    if (_isDisposing) return;
    tourProvider.completeTour();
    tourProvider.clearMockOrder();
    orderProvider?.clearMockOrder();

    // Navigate back to home
    tourProvider.navigateToTab(0);

    // Show completion dialog after navigation
    Future.delayed(const Duration(milliseconds: 400), () {
      if (context.mounted) {
        TourCompletionDialog.show(
          context,
          onClose: () {
            onComplete?.call();
          },
          onViewKnowledgeBase: () {
            if (context.mounted) {
              context.push(RouteConstants.knowledgeBase);
            }
          },
        );
      }
    });
  }

  /// Handle tour skip
  void _handleSkip() {
    if (_isDisposing) return;
    _tutorialCoachMark?.finish();

    // If we're on a pushed route (order detail or navigation), pop back first
    final stage = tourProvider.currentStage;
    if (stage == TourStage.orderDetail || stage == TourStage.ongoingTrip) {
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }

    tourProvider.skipTour();
    tourProvider.clearMockOrder();
    orderProvider?.clearMockOrder();

    // Navigate back to home
    Future.delayed(const Duration(milliseconds: 200), () {
      tourProvider.navigateToTab(0);
    });

    onSkip?.call();
  }

  /// Dispose resources. Sets _isDisposing so finish callbacks
  /// don't call notifyListeners during widget tree teardown.
  void dispose() {
    _isDisposing = true;
    _tutorialCoachMark?.finish();
    _tutorialCoachMark = null;
  }

  // ========== Target Creation Methods ==========

  /// Helper to create a TargetFocus with rectangular highlight.
  TargetFocus _target({
    required String id,
    required GlobalKey key,
    required List<TargetContent> contents,
  }) {
    return TargetFocus(
      identify: id,
      keyTarget: key,
      shape: ShapeLightFocus.RRect,
      radius: 14,
      paddingFocus: 6,
      contents: contents,
    );
  }

  List<TargetFocus> _createHomeTargets() {
    final targets = <TargetFocus>[];
    final keys = TourKeys.instance;
    final l10n = AppLocalizations.of(context)!;

    if (keys.verificationBannerKey.currentContext != null) {
      targets.add(_target(
        id: "verification_banner",
        key: keys.verificationBannerKey,
        contents: [_buildContent(
          title: l10n.tourAccountUnderReviewTitle,
          description: l10n.tourAccountUnderReviewDesc,
          step: 1, totalSteps: 3,
          below: true,
        )],
      ));
    }

    if (keys.onlineToggleKey.currentContext != null) {
      targets.add(_target(
        id: "online_toggle",
        key: keys.onlineToggleKey,
        contents: [_buildContent(
          title: l10n.tourGoOnlineTitle,
          description: l10n.tourGoOnlineDesc,
          step: 2, totalSteps: 3,
          below: true,
        )],
      ));
    }

    if (keys.statsCardKey.currentContext != null) {
      targets.add(_target(
        id: "stats_card",
        key: keys.statsCardKey,
        contents: [_buildContent(
          title: l10n.tourDailyStatsTitle,
          description: l10n.tourDailyStatsDesc,
          step: 3, totalSteps: 3, isLast: true,
          below: false, // above the element — keeps it away from nav bar
        )],
      ));
    }

    return targets;
  }

  List<TargetFocus> _createOrderAcceptanceTargets() {
    final targets = <TargetFocus>[];
    final keys = TourKeys.instance;
    final l10n = AppLocalizations.of(context)!;

    if (keys.newOrderCardKey.currentContext != null) {
      targets.add(_target(
        id: "new_order_card",
        key: keys.newOrderCardKey,
        contents: [_buildContent(
          title: l10n.tourNewOrderTitle,
          description: l10n.tourNewOrderDesc,
          step: 1, totalSteps: 1, isLast: true,
          below: false,
        )],
      ));
    }

    return targets;
  }

  List<TargetFocus> _createOrdersTargets() {
    final targets = <TargetFocus>[];
    final keys = TourKeys.instance;
    final l10n = AppLocalizations.of(context)!;

    if (keys.tabBarKey.currentContext != null) {
      targets.add(_target(
        id: "orders_tab_bar",
        key: keys.tabBarKey,
        contents: [_buildContent(
          title: l10n.tourOrdersTabTitle,
          description: l10n.tourOrdersTabDesc,
          step: 1, totalSteps: 1, isLast: true,
          below: true,
        )],
      ));
    }

    return targets;
  }

  List<TargetFocus> _createEarningsTargets() {
    final targets = <TargetFocus>[];
    final keys = TourKeys.instance;
    final l10n = AppLocalizations.of(context)!;

    if (keys.totalEarningsKey.currentContext != null) {
      targets.add(_target(
        id: "total_earnings",
        key: keys.totalEarningsKey,
        contents: [_buildContent(
          title: l10n.tourTotalEarningsTitle,
          description: l10n.tourTotalEarningsDesc,
          step: 1, totalSteps: 2,
          below: true,
        )],
      ));
    }

    if (keys.statsGridKey.currentContext != null) {
      targets.add(_target(
        id: "earnings_stats",
        key: keys.statsGridKey,
        contents: [_buildContent(
          title: l10n.tourEarningsBreakdownTitle,
          description: l10n.tourEarningsBreakdownDesc,
          step: 2, totalSteps: 2, isLast: true,
          below: false,
        )],
      ));
    }

    return targets;
  }

  List<TargetFocus> _createOrderDetailTargets() {
    final targets = <TargetFocus>[];
    final keys = TourKeys.instance;
    final l10n = AppLocalizations.of(context)!;

    if (keys.orderDetailRouteCardKey.currentContext != null) {
      targets.add(_target(
        id: "order_detail_route",
        key: keys.orderDetailRouteCardKey,
        contents: [_buildContent(
          title: l10n.tourRouteDetailsTitle,
          description: l10n.tourRouteDetailsDesc,
          step: 1, totalSteps: 3,
          below: true,
        )],
      ));
    }

    if (keys.orderDetailEarningsCardKey.currentContext != null) {
      targets.add(_target(
        id: "order_detail_earnings",
        key: keys.orderDetailEarningsCardKey,
        contents: [_buildContent(
          title: l10n.tourYourEarningsTitle,
          description: l10n.tourYourEarningsDesc,
          step: 2, totalSteps: 3,
          below: false,
        )],
      ));
    }

    if (keys.orderDetailBottomBarKey.currentContext != null) {
      targets.add(_target(
        id: "order_detail_bottom_bar",
        key: keys.orderDetailBottomBarKey,
        contents: [_buildContent(
          title: l10n.tourNavActionsTitle,
          description: l10n.tourNavActionsDesc,
          step: 3, totalSteps: 3, isLast: true,
          below: false,
        )],
      ));
    }

    return targets;
  }

  List<TargetFocus> _createNavigationTargets() {
    final targets = <TargetFocus>[];
    final keys = TourKeys.instance;
    final l10n = AppLocalizations.of(context)!;

    if (keys.navigationInstructionCardKey.currentContext != null) {
      targets.add(_target(
        id: "navigation_instruction",
        key: keys.navigationInstructionCardKey,
        contents: [_buildContent(
          title: l10n.tourTurnByTurnTitle,
          description: l10n.tourTurnByTurnDesc,
          step: 1, totalSteps: 3,
          below: true,
        )],
      ));
    }

    if (keys.navigationBottomPanelKey.currentContext != null) {
      targets.add(_target(
        id: "navigation_bottom_panel",
        key: keys.navigationBottomPanelKey,
        contents: [_buildContent(
          title: l10n.tourTripControlsTitle,
          description: l10n.tourTripControlsDesc,
          step: 2, totalSteps: 3,
          below: false,
        )],
      ));
    }

    if (keys.navigationActionButtonKey.currentContext != null) {
      targets.add(_target(
        id: "navigation_action_button",
        key: keys.navigationActionButtonKey,
        contents: [_buildContent(
          title: l10n.tourUpdateStatusTitle,
          description: l10n.tourUpdateStatusDesc,
          step: 3, totalSteps: 3, isLast: true,
          below: false,
        )],
      ));
    }

    return targets;
  }

  List<TargetFocus> _createProfileTargets() {
    final targets = <TargetFocus>[];
    final keys = TourKeys.instance;
    final l10n = AppLocalizations.of(context)!;

    if (keys.settingsMenuKey.currentContext != null) {
      targets.add(_target(
        id: "settings_menu",
        key: keys.settingsMenuKey,
        contents: [_buildContent(
          title: l10n.tourAppSettingsTitle,
          description: l10n.tourAppSettingsDesc,
          step: 1, totalSteps: 2,
          below: true,
        )],
      ));
    }

    if (keys.kbMenuKey.currentContext != null) {
      targets.add(_target(
        id: "kb_menu",
        key: keys.kbMenuKey,
        contents: [_buildContent(
          title: l10n.tourKnowledgeBaseTitle,
          description: l10n.tourKnowledgeBaseDesc,
          step: 2, totalSteps: 2, isLast: true,
          below: false,
        )],
      ));
    }

    return targets;
  }

  /// Build content for a tour target.
  /// [below] = true → tooltip below the target (for elements at top of screen).
  /// [below] = false → tooltip above the target (for elements near bottom/nav bar).
  TargetContent _buildContent({
    required String title,
    required String description,
    required int step,
    required int totalSteps,
    bool isLast = false,
    bool below = true,
  }) {
    return TargetContent(
      align: below ? ContentAlign.bottom : ContentAlign.top,
      padding: EdgeInsets.only(
        top: below ? 10 : 0,
        bottom: below ? 0 : 10,
      ),
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
            // Always use next() — on the last target it triggers onFinish.
            // Using skip() would fire onSkip AND onFinish, causing the tour
            // to be cancelled before _completeStage can continue the flow.
            controller.next();
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
