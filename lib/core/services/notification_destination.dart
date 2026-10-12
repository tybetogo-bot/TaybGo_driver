import '../constants/route_constants.dart';

/// Only routes supported notification types to destinations owned by this app.
String notificationDestination(Map<String, dynamic> data) {
  final type = data['type']?.toString();
  if (type == 'order_update') {
    final id = (data['order_id'] ?? data['orderId'] ?? data['id'])
        ?.toString()
        .trim();
    if (id != null && id.isNotEmpty) {
      return RouteConstants.orderDetailPath(Uri.encodeComponent(id));
    }
  }
  // New offers are accepted from the dispatch UI on Home.
  return RouteConstants.home;
}
