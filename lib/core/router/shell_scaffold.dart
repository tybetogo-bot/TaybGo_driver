import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../constants/route_constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/tour_provider.dart';
import '../providers/order_provider.dart';
import '../../features/tour/tour_coordinator.dart';

class ShellScaffold extends StatefulWidget {
  final Widget child;

  const ShellScaffold({
    super.key,
    required this.child,
  });

  @override
  State<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<ShellScaffold> {
  TourCoordinator? _tourCoordinator;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tourProvider = context.read<TourProvider>();
      tourProvider.setTabNavigationCallback(_navigateToTab);
      tourProvider.setTourStartCallback(_onTourStarted);
    });
  }

  @override
  void dispose() {
    try {
      final tourProvider = context.read<TourProvider>();
      tourProvider.setTabNavigationCallback(null);
      tourProvider.setTourStartCallback(null);
    } catch (_) {}
    _tourCoordinator?.dispose();
    super.dispose();
  }

  /// Called directly by TourProvider.startTour()
  void _onTourStarted() {
    debugPrint('[Tour] ShellScaffold._onTourStarted called');
    final tourProvider = context.read<TourProvider>();
    final orderProvider = context.read<OrderProvider>();

    _tourCoordinator?.dispose();
    _tourCoordinator = TourCoordinator(
      context: context,
      tourProvider: tourProvider,
      orderProvider: orderProvider,
      onComplete: () {
        debugPrint('[Tour] ShellScaffold: tour onComplete');
        _tourCoordinator = null;
        if (mounted) setState(() {});
      },
      onSkip: () {
        debugPrint('[Tour] ShellScaffold: tour onSkip');
        _tourCoordinator = null;
        if (mounted) setState(() {});
      },
    );

    // Small delay so the current notifyListeners() cycle and any
    // resulting rebuilds settle before we start showing overlays.
    Future.delayed(const Duration(milliseconds: 400), () {
      debugPrint('[Tour] ShellScaffold: delayed callback, mounted=$mounted, isTourActive=${tourProvider.isTourActive}, coordinator=${_tourCoordinator != null}');
      if (mounted && tourProvider.isTourActive) {
        _tourCoordinator?.startTour(stage: tourProvider.currentStage);
      }
    });
  }

  void _navigateToTab(int index) {
    if (!mounted) return;
    switch (index) {
      case 0:
        context.go(RouteConstants.home);
        break;
      case 1:
        context.go(RouteConstants.orders);
        break;
      case 2:
        context.go(RouteConstants.earnings);
        break;
      case 3:
        context.go(RouteConstants.profile);
        break;
    }
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(RouteConstants.home)) return 0;
    if (location.startsWith(RouteConstants.orders)) return 1;
    if (location.startsWith(RouteConstants.earnings)) return 2;
    if (location.startsWith(RouteConstants.profile)) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteConstants.home);
        break;
      case 1:
        context.go(RouteConstants.orders);
        break;
      case 2:
        context.go(RouteConstants.earnings);
        break;
      case 3:
        context.go(RouteConstants.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getSelectedIndex(context),
        onTap: (index) => _onItemTapped(context, index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long_outlined),
            activeIcon: const Icon(Icons.receipt_long),
            label: l10n.orders,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            activeIcon: const Icon(Icons.account_balance_wallet),
            label: l10n.earnings_label,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}
