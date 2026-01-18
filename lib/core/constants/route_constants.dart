class RouteConstants {
  RouteConstants._();

  // Onboarding
  static const String onboarding = '/onboarding';

  // Auth
  static const String phone = '/phone';
  static const String otp = '/otp';

  // Application
  static const String application = '/application';
  static const String pendingApproval = '/pending-approval';

  // Main tabs
  static const String home = '/home';
  static const String orders = '/orders';
  static const String earnings = '/earnings';
  static const String profile = '/profile';

  // Sub-screens
  static const String orderDetail = '/order/:id';
  static const String navigation = '/navigation/:id';
  static const String settings = '/settings';
  static const String notifications = '/notifications';

  // Helper methods
  static String orderDetailPath(String id) => '/order/$id';
  static String navigationPath(String id) => '/navigation/$id';
}
