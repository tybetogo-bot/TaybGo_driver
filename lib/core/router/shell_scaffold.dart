import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../constants/route_constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/tour_provider.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Register the tab navigation callback with TourProvider
      final tourProvider = context.read<TourProvider>();
      tourProvider.setTabNavigationCallback(_navigateToTab);
    });
  }

  @override
  void dispose() {
    // Unregister callback on dispose
    try {
      final tourProvider = context.read<TourProvider>();
      tourProvider.setTabNavigationCallback(null);
    } catch (_) {}
    super.dispose();
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
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
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
      ),
    );
  }
}
