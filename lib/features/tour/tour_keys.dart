import 'package:flutter/material.dart';

/// Global keys for tour targets across different screens
/// This singleton class provides access to GlobalKeys for the tour coordinator
class TourKeys {
  // Singleton pattern
  TourKeys._();
  static final TourKeys instance = TourKeys._();

  // Home Screen Keys
  final GlobalKey onlineToggleKey = GlobalKey();
  final GlobalKey statsCardKey = GlobalKey();
  final GlobalKey verificationBannerKey = GlobalKey();
  final GlobalKey newOrderCardKey = GlobalKey();

  // Orders Screen Keys
  final GlobalKey tabBarKey = GlobalKey();
  final GlobalKey currentOrdersKey = GlobalKey();
  final GlobalKey historyKey = GlobalKey();

  // Earnings Screen Keys
  final GlobalKey totalEarningsKey = GlobalKey();
  final GlobalKey statsGridKey = GlobalKey();

  // Order Detail Screen Keys
  final GlobalKey orderDetailRouteCardKey = GlobalKey();
  final GlobalKey orderDetailEarningsCardKey = GlobalKey();
  final GlobalKey orderDetailBottomBarKey = GlobalKey();

  // Navigation Screen Keys
  final GlobalKey navigationInstructionCardKey = GlobalKey();
  final GlobalKey navigationBottomPanelKey = GlobalKey();
  final GlobalKey navigationActionButtonKey = GlobalKey();

  // Profile Screen Keys
  final GlobalKey settingsMenuKey = GlobalKey();
  final GlobalKey kbMenuKey = GlobalKey();

  /// Reset all keys (useful for hot reload during development)
  void reset() {
    // Keys are automatically recreated when accessed after being disposed
    // This method can be used if manual reset is needed
  }
}
