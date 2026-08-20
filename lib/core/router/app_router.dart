import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/phone_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/application/screens/application_screen.dart';
import '../../features/application/screens/pending_approval_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/orders/screens/orders_screen.dart';
import '../../features/orders/screens/order_detail_screen.dart';
import '../../features/navigation/screens/navigation_screen.dart';
import '../../features/earnings/screens/earnings_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/changelog_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/knowledge_base/screens/knowledge_base_screen.dart';
import '../../features/knowledge_base/screens/kb_article_screen.dart';
import '../../features/knowledge_base/models/kb_models.dart';
import '../../features/support/presentation/screens/support_tickets_screen.dart';
import '../../features/support/presentation/screens/ticket_detail_screen.dart';
import '../../features/support/presentation/screens/create_ticket_screen.dart';
import '../constants/route_constants.dart';
import '../providers/auth_provider.dart';
import 'shell_scaffold.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: RouteConstants.phone,
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final currentPath = state.matchedLocation;

        debugPrint(
          '[Router] Redirect check - path: $currentPath, isAuth: $isAuthenticated',
        );

        // Wait for stored credentials to be restored before protecting routes.
        // This prevents an authenticated app reload from briefly redirecting
        // away from the application flow.
        if (!authProvider.initialized) {
          return null;
        }

        // If authenticated, redirect from auth routes
        if (isAuthenticated) {
          if (currentPath == RouteConstants.onboarding ||
              currentPath == RouteConstants.phone ||
              currentPath == RouteConstants.otp) {
            // New users need to complete their profile first
            if (authProvider.isNewUser) {
              debugPrint(
                '[Router] Redirecting to application (new user needs profile)',
              );
              return RouteConstants.application;
            }
            debugPrint(
              '[Router] Redirecting to home (authenticated on auth route)',
            );
            return RouteConstants.home;
          }
          return null;
        }

        // Not authenticated below this point

        // Only authentication routes are public. The application and pending
        // approval screens submit or expose driver data and require a session.
        if (currentPath == RouteConstants.onboarding ||
            currentPath == RouteConstants.phone ||
            currentPath == RouteConstants.otp) {
          debugPrint('[Router] Allowing access to: $currentPath');
          return null;
        }

        // If not authenticated and trying to access protected route, redirect to login.
        debugPrint('[Router] Redirecting to phone (fallback)');
        return RouteConstants.phone;
      },
      routes: [
        // Legacy onboarding path now opens login directly.
        GoRoute(
          path: RouteConstants.onboarding,
          builder: (context, state) => const PhoneScreen(),
        ),

        // Auth
        GoRoute(
          path: RouteConstants.phone,
          builder: (context, state) => const PhoneScreen(),
        ),
        GoRoute(
          path: RouteConstants.otp,
          builder: (context, state) {
            final phone = state.extra as String? ?? '';
            return OtpScreen(phoneNumber: phone);
          },
        ),

        // Application
        GoRoute(
          path: RouteConstants.application,
          builder: (context, state) => const ApplicationScreen(),
        ),
        GoRoute(
          path: RouteConstants.pendingApproval,
          builder: (context, state) => const PendingApprovalScreen(),
        ),

        // Main App with Bottom Navigation
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) => ShellScaffold(child: child),
          routes: [
            GoRoute(
              path: RouteConstants.home,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomeScreen()),
            ),
            GoRoute(
              path: RouteConstants.orders,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: OrdersScreen()),
            ),
            GoRoute(
              path: RouteConstants.earnings,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: EarningsScreen()),
            ),
            GoRoute(
              path: RouteConstants.profile,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfileScreen()),
            ),
          ],
        ),

        // Standalone screens (no bottom nav)
        GoRoute(
          path: RouteConstants.orderDetail,
          builder: (context, state) {
            final orderId = state.pathParameters['id'] ?? '';
            return OrderDetailScreen(orderId: orderId);
          },
        ),
        GoRoute(
          path: RouteConstants.navigation,
          builder: (context, state) {
            final orderId = state.pathParameters['id'] ?? '';
            return NavigationScreen(orderId: orderId);
          },
        ),
        GoRoute(
          path: RouteConstants.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: RouteConstants.notifications,
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: RouteConstants.editProfile,
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: RouteConstants.changelog,
          builder: (context, state) => const ChangelogScreen(),
        ),

        // Knowledge Base
        GoRoute(
          path: RouteConstants.knowledgeBase,
          builder: (context, state) => const KnowledgeBaseScreen(),
        ),
        GoRoute(
          path: RouteConstants.kbArticle,
          builder: (context, state) {
            final categoryId = state.pathParameters['categoryId'] ?? '';
            final articleId = state.pathParameters['articleId'] ?? '';
            final article = state.extra as KBArticle?;
            return KBArticleScreen(
              categoryId: categoryId,
              articleId: articleId,
              article: article,
            );
          },
        ),

        // Support
        GoRoute(
          path: RouteConstants.support,
          builder: (context, state) => const SupportTicketsScreen(),
        ),
        GoRoute(
          path: RouteConstants.supportTicketDetail,
          builder: (context, state) {
            final ticketId = state.pathParameters['ticketId'] ?? '';
            return TicketDetailScreen(ticketId: ticketId);
          },
        ),
        GoRoute(
          path: RouteConstants.supportCreate,
          builder: (context, state) => const CreateTicketScreen(),
        ),
      ],
    );
  }
}
