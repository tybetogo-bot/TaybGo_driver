import '../config/app_config.dart';

class ApiConstants {
  static String get baseUrl => AppConfig.baseUrl;

  // Auth endpoints
  static const String otpRequest = '/auth/otp/request/';
  static const String otpVerify = '/auth/otp/verify/';
  static const String passwordLogin = '/auth/token/';
  static const String tokenRefresh = '/auth/token/refresh/';
  static const String logout = '/auth/logout/';

  // Anonymous runtime configuration
  static const String publicConfig = '/config/public';

  // Driver endpoints
  static const String driverProfile = '/driver/profile/';
  static const String driverCreate =
      '/driver/profile/'; // POST to same endpoint as GET
  static const String driverToggleOnline = '/drivers/toggle-online/';
  static const String driverLocation = '/drivers/location/';
  static const String suggestedOrders = '/drivers/suggested-orders/';
  static const String acceptOrder = '/drivers/accept-order/';
  static const String rejectOrder = '/drivers/reject-order/';
  static const String dropOrder = '/drivers/drop-order/';
  static const String updateOrderStatus = '/drivers/update-order-status/';

  // User endpoints
  static const String userMe = '/me/';

  // Support
  static const String supportTickets = '/driver/support/tickets/';
  static String supportTicketDetail(int id) => '/driver/support/tickets/$id/';
  static String supportTicketMessages(int id) =>
      '/driver/support/tickets/$id/messages/';

  // Earnings
  static const String driverEarnings = '/drivers/earnings/';

  // Notifications
  static const String notifications = '/notifications';
  static const String deviceToken = '/notifications/device';
}
