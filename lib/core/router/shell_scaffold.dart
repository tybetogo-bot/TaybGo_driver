import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/route_constants.dart';
import '../l10n/app_localizations.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;

  const ShellScaffold({
    super.key,
    required this.child,
  });

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
      body: child,
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
