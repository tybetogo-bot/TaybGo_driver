import 'package:flutter/material.dart';

enum TourStage {
  home,
  orderAcceptance,
  activeOrder,
  orderDetail,
  ongoingTrip,
  orders,
  earnings,
  profile,
}

enum TooltipPosition {
  top,
  bottom,
  left,
  right,
  center,
}

enum TourAction {
  next,
  previous,
  skip,
  complete,
}

class TourStep {
  final String titleKey;
  final String descriptionKey;
  final GlobalKey? targetKey;
  final TooltipPosition position;
  final String? illustrationAsset;
  final List<TourAction> actions;
  final VoidCallback? onShow;
  final VoidCallback? onNext;

  TourStep({
    required this.titleKey,
    required this.descriptionKey,
    this.targetKey,
    this.position = TooltipPosition.bottom,
    this.illustrationAsset,
    this.actions = const [TourAction.next],
    this.onShow,
    this.onNext,
  });
}

class TourProgress {
  final TourStage currentStage;
  final int currentStep;
  final int totalStepsInStage;
  final int stageIndex;
  final int totalStages;

  TourProgress({
    required this.currentStage,
    required this.currentStep,
    required this.totalStepsInStage,
    required this.stageIndex,
    required this.totalStages,
  });

  double get overallProgress {
    final stepProgress = currentStep / totalStepsInStage;
    return (stageIndex + stepProgress) / totalStages;
  }

  int get overallPercentage => (overallProgress * 100).round();

  String get progressText => 'Stage ${stageIndex + 1} of $totalStages';
}
