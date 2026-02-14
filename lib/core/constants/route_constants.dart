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

  // Knowledge Base
  static const String knowledgeBase = '/knowledge-base';
  static const String kbArticle = '/knowledge-base/:categoryId/:articleId';

  // Support
  static const String support = '/support';
  static const String supportTicketDetail = '/support/ticket/:ticketId';
  static const String supportCreate = '/support/create';

  // Helper methods
  static String orderDetailPath(String id) => '/order/$id';
  static String navigationPath(String id) => '/navigation/$id';
  static String kbArticlePath(String categoryId, String articleId) =>
      '/knowledge-base/$categoryId/$articleId';
  static String supportTicketDetailPath(String ticketId) =>
      '/support/ticket/$ticketId';
}
