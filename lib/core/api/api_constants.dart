class ApiConstants {
  static const String baseUrl = 'https://taybat-backend.onrender.com/api';

  // Auth endpoints
  static const String otpRequest = '/auth/otp/request/';
  static const String otpVerify = '/auth/otp/verify/';
  static const String tokenRefresh = '/auth/token/refresh/';
  static const String tokenBlacklist = '/auth/token/blacklist/';

  // Driver endpoints
  static const String driverProfile = '/driver/profile/';
  static const String driverCreate = '/drivers/';
  static const String driverToggleOnline = '/drivers/toggle-online/';
  static const String driverLocation = '/drivers/location/';
  static const String suggestedOrders = '/drivers/suggested-orders/';
  static const String acceptOrder = '/drivers/accept-order/';
  static const String rejectOrder = '/drivers/reject-order/';
  static const String updateOrderStatus = '/drivers/update-order-status/';

  // User endpoints
  static const String userMe = '/me/';

  // Notifications
  static const String notifications = '/notifications';
  static const String deviceToken = '/notifications/device';
}
