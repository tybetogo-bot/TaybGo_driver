import 'package:flutter/material.dart';
import '../../features/orders/models/order_model.dart';
import '../models/tour_models.dart';
import '../services/tour_storage_service.dart';
import '../mock/tour_mock_data.dart';

class TourProvider extends ChangeNotifier {
  final TourStorageService _storageService = TourStorageService();

  bool _isTourActive = false;
  bool _isTourCompleted = false;
  bool _hasSkippedTour = false;
  TourStage _currentStage = TourStage.home;
  int _currentStepInStage = 0;
  OrderModel? _mockOrder;

  /// Callback to navigate to a specific tab during tour
  void Function(int tabIndex)? _tabNavigationCallback;

  /// Callback to trigger showing the tour for current stage
  void Function()? _showStageCallback;

  /// Callback invoked when the tour is started (used by ShellScaffold)
  void Function()? _tourStartCallback;

  // Getters
  bool get isTourActive => _isTourActive;
  bool get isTourCompleted => _isTourCompleted;
  bool get hasSkippedTour => _hasSkippedTour;
  TourStage get currentStage => _currentStage;
  int get currentStepInStage => _currentStepInStage;
  OrderModel? get mockOrder => _mockOrder;

  /// Register a callback for tab navigation (called by ShellScaffold)
  void setTabNavigationCallback(void Function(int tabIndex)? callback) {
    _tabNavigationCallback = callback;
  }

  /// Register a callback to show the tour stage (called by each screen)
  void setShowStageCallback(void Function()? callback) {
    _showStageCallback = callback;
  }

  /// Register a callback for when the tour starts (called by ShellScaffold)
  void setTourStartCallback(void Function()? callback) {
    _tourStartCallback = callback;
  }

  /// Navigate to a specific tab during tour
  void navigateToTab(int tabIndex) {
    _tabNavigationCallback?.call(tabIndex);
  }

  /// Trigger showing the current tour stage
  void triggerShowStage() {
    _showStageCallback?.call();
  }

  /// Get the tab index for a tour stage
  int getTabIndexForStage(TourStage stage) {
    switch (stage) {
      case TourStage.home:
      case TourStage.orderAcceptance:
      case TourStage.activeOrder:
        return 0; // Home tab
      case TourStage.orderDetail:
      case TourStage.ongoingTrip:
        return -1; // Pushed routes, not tabs
      case TourStage.orders:
        return 1; // Orders tab
      case TourStage.earnings:
        return 2; // Earnings tab
      case TourStage.profile:
        return 3; // Profile tab
    }
  }

  /// Initialize tour state from storage
  Future<void> init() async {
    _isTourCompleted = await _storageService.isTourCompleted();
    // Skip is session-only: unverified users should always see the tour
    // card on each app launch until they complete the tour.
    _hasSkippedTour = false;
    notifyListeners();
  }

  /// Check if the tour welcome prompt should be shown.
  /// Returns true if user is unverified and hasn't skipped the tour this session.
  /// The card stays available even after completing the tour — as long as the
  /// account is still under review the driver can retake it.
  bool shouldShowPrompt(bool isVerified) {
    return !isVerified && !_hasSkippedTour;
  }

  /// Start the tour
  Future<void> startTour() async {
    _isTourActive = true;
    _currentStage = TourStage.home;
    _currentStepInStage = 0;
    await _storageService.setLastTourStage(TourStage.home.name);
    notifyListeners();
    // Notify ShellScaffold to create the coordinator and run the tour
    _tourStartCallback?.call();
  }

  /// Pause the tour (e.g., when user navigates away)
  void pauseTour() {
    _isTourActive = false;
    notifyListeners();
  }

  /// Resume the tour from where it was paused
  Future<void> resumeTour() async {
    final lastStageStr = await _storageService.getLastTourStage();
    if (lastStageStr != null) {
      try {
        _currentStage = TourStage.values.byName(lastStageStr);
      } catch (e) {
        _currentStage = TourStage.home;
      }
    }
    _isTourActive = true;
    notifyListeners();
  }

  /// Complete the tour
  Future<void> completeTour() async {
    _isTourActive = false;
    _isTourCompleted = true;
    await _storageService.setTourCompleted(true);
    _mockOrder = null;
    notifyListeners();
  }

  /// Skip the tour
  Future<void> skipTour() async {
    _isTourActive = false;
    _hasSkippedTour = true;
    await _storageService.incrementTourSkipCount();
    _mockOrder = null;
    notifyListeners();
  }

  /// Move to next stage
  void nextStage() {
    final stages = TourStage.values;
    final currentIndex = stages.indexOf(_currentStage);
    if (currentIndex < stages.length - 1) {
      _currentStage = stages[currentIndex + 1];
      _currentStepInStage = 0;
      _storageService.setLastTourStage(_currentStage.name);
      notifyListeners();
    }
  }

  /// Move to previous stage
  void previousStage() {
    final stages = TourStage.values;
    final currentIndex = stages.indexOf(_currentStage);
    if (currentIndex > 0) {
      _currentStage = stages[currentIndex - 1];
      _currentStepInStage = 0;
      _storageService.setLastTourStage(_currentStage.name);
      notifyListeners();
    }
  }

  /// Set current stage directly
  void setStage(TourStage stage) {
    _currentStage = stage;
    _currentStepInStage = 0;
    if (_isTourActive) {
      _storageService.setLastTourStage(stage.name);
    }
    notifyListeners();
  }

  /// Increment step within current stage
  void nextStep() {
    _currentStepInStage++;
    notifyListeners();
  }

  /// Decrement step within current stage
  void previousStep() {
    if (_currentStepInStage > 0) {
      _currentStepInStage--;
      notifyListeners();
    }
  }

  /// Set step directly
  void setStep(int step) {
    _currentStepInStage = step;
    notifyListeners();
  }

  /// Inject mock order for tour demonstration
  void setMockOrder(OrderModel? order) {
    _mockOrder = order;
    notifyListeners();
  }

  /// Create and inject a new mock order
  void injectMockOrder() {
    _mockOrder = TourMockData.createMockOrder();
    notifyListeners();
  }

  /// Remove mock order
  void clearMockOrder() {
    _mockOrder = null;
    notifyListeners();
  }

  /// Update mock order status (for simulating order lifecycle)
  void updateMockOrderStatus(OrderStatus status) {
    if (_mockOrder != null) {
      _mockOrder = _mockOrder!.copyWith(
        status: status,
        acceptedAt: status == OrderStatus.accepted ? DateTime.now() : _mockOrder!.acceptedAt,
        completedAt: (status == OrderStatus.delivered || status == OrderStatus.completed)
            ? DateTime.now()
            : _mockOrder!.completedAt,
      );
      notifyListeners();
    }
  }

  /// Reset tour to allow taking it again
  Future<void> resetTour() async {
    await _storageService.resetTour();
    _isTourActive = false;
    _isTourCompleted = false;
    _hasSkippedTour = false;
    _currentStage = TourStage.home;
    _currentStepInStage = 0;
    _mockOrder = null;
    notifyListeners();
  }

  /// Get current tour progress
  TourProgress getProgress({required int totalStepsInStage}) {
    final stages = TourStage.values;
    final stageIndex = stages.indexOf(_currentStage);

    return TourProgress(
      currentStage: _currentStage,
      currentStep: _currentStepInStage,
      totalStepsInStage: totalStepsInStage,
      stageIndex: stageIndex,
      totalStages: stages.length,
    );
  }

  /// Check if an order is a mock tour order
  bool isMockOrder(String? orderId) {
    if (orderId == null) return false;
    return TourMockData.isMockOrder(orderId);
  }
}
