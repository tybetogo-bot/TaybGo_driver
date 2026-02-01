import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../../features/orders/models/order_model.dart';

class OrderService {
  final ApiClient _apiClient;

  OrderService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Fetch suggested orders available for the driver
  Future<List<OrderModel>> getSuggestedOrders() async {
    try {
      debugPrint('[OrderService] === GET SUGGESTED ORDERS REQUEST ===');
      debugPrint('[OrderService] Endpoint: ${ApiConstants.suggestedOrders}');

      final response = await _apiClient.get(ApiConstants.suggestedOrders);

      debugPrint('[OrderService] === GET SUGGESTED ORDERS RESPONSE ===');
      debugPrint('[OrderService] Status: ${response.statusCode}');
      debugPrint('[OrderService] Data: ${response.data}');

      final List<OrderModel> orders = [];

      // Handle paginated response
      if (response.data is Map && response.data['results'] != null) {
        for (final json in response.data['results']) {
          orders.add(OrderModel.fromJson(json));
        }
      } else if (response.data is List) {
        for (final json in response.data) {
          orders.add(OrderModel.fromJson(json));
        }
      }

      debugPrint('[OrderService] Parsed ${orders.length} orders');
      return orders;
    } on DioException catch (e) {
      debugPrint('[OrderService] Get Suggested Orders Error: ${e.message}');
      debugPrint('[OrderService] Error Response: ${e.response?.data}');
      throw ApiException.fromDioException(e);
    }
  }

  /// Accept an order - uses atomic locking on backend
  /// Returns the accepted order, or throws on conflict (409)
  Future<OrderModel> acceptOrder(String orderId) async {
    try {
      debugPrint('[OrderService] === ACCEPT ORDER REQUEST ===');
      debugPrint('[OrderService] Endpoint: ${ApiConstants.acceptOrder}');
      debugPrint('[OrderService] Data: {order_id: $orderId}');

      final response = await _apiClient.post(
        ApiConstants.acceptOrder,
        data: {'order_id': int.tryParse(orderId) ?? orderId},
      );

      debugPrint('[OrderService] === ACCEPT ORDER RESPONSE ===');
      debugPrint('[OrderService] Status: ${response.statusCode}');
      debugPrint('[OrderService] Data: ${response.data}');

      // Backend may return order details or just confirmation
      if (response.data is Map && response.data['order'] != null) {
        return OrderModel.fromJson(response.data['order']);
      }

      // If no order returned, fetch it
      return getOrderDetails(orderId);
    } on DioException catch (e) {
      debugPrint('[OrderService] Accept Order Error: ${e.message}');
      debugPrint('[OrderService] Error Response: ${e.response?.data}');
      if (e.response?.statusCode == 409) {
        throw ApiException(
          message: 'Order already taken by another driver',
          statusCode: 409,
        );
      }
      if (e.response?.statusCode == 403) {
        throw ApiException(
          message: 'Order suggestion expired',
          statusCode: 403,
        );
      }
      if (e.response?.statusCode == 404) {
        throw ApiException(
          message: 'Order not found',
          statusCode: 404,
        );
      }
      throw ApiException.fromDioException(e);
    }
  }

  /// Reject/skip an order
  Future<void> rejectOrder(String orderId) async {
    try {
      debugPrint('[OrderService] === REJECT ORDER REQUEST ===');
      debugPrint('[OrderService] Endpoint: ${ApiConstants.rejectOrder}');
      debugPrint('[OrderService] Data: {order_id: $orderId}');

      final response = await _apiClient.post(
        ApiConstants.rejectOrder,
        data: {'order_id': int.tryParse(orderId) ?? orderId},
      );

      debugPrint('[OrderService] === REJECT ORDER RESPONSE ===');
      debugPrint('[OrderService] Status: ${response.statusCode}');
      debugPrint('[OrderService] Data: ${response.data}');
    } on DioException catch (e) {
      debugPrint('[OrderService] Reject Order Error: ${e.message}');
      debugPrint('[OrderService] Error Response: ${e.response?.data}');
      throw ApiException.fromDioException(e);
    }
  }

  /// Update order status (ACCEPTED -> ON_THE_WAY -> DELIVERED -> COMPLETED)
  Future<OrderModel> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      debugPrint('[OrderService] === UPDATE ORDER STATUS REQUEST ===');
      debugPrint('[OrderService] Endpoint: ${ApiConstants.updateOrderStatus}');
      debugPrint('[OrderService] Data: {order_id: $orderId, status: ${newStatus.apiValue}}');

      final response = await _apiClient.post(
        ApiConstants.updateOrderStatus,
        data: {
          'order_id': int.tryParse(orderId) ?? orderId,
          'status': newStatus.apiValue,
        },
      );

      debugPrint('[OrderService] === UPDATE ORDER STATUS RESPONSE ===');
      debugPrint('[OrderService] Status: ${response.statusCode}');
      debugPrint('[OrderService] Data: ${response.data}');

      if (response.data is Map && response.data['order'] != null) {
        return OrderModel.fromJson(response.data['order']);
      }

      // Return updated order model
      return getOrderDetails(orderId);
    } on DioException catch (e) {
      debugPrint('[OrderService] Update Order Status Error: ${e.message}');
      debugPrint('[OrderService] Error Response: ${e.response?.data}');
      if (e.response?.statusCode == 400) {
        final detail = e.response?.data is Map ? e.response?.data['detail'] : null;
        throw ApiException(
          message: detail?.toString() ?? 'Invalid status transition',
          statusCode: 400,
        );
      }
      throw ApiException.fromDioException(e);
    }
  }

  /// Get order details by ID
  Future<OrderModel> getOrderDetails(String orderId) async {
    try {
      debugPrint('[OrderService] === GET ORDER DETAILS REQUEST ===');
      debugPrint('[OrderService] Endpoint: /orders/$orderId/');

      final response = await _apiClient.get('/orders/$orderId/');

      debugPrint('[OrderService] === GET ORDER DETAILS RESPONSE ===');
      debugPrint('[OrderService] Status: ${response.statusCode}');
      debugPrint('[OrderService] Data: ${response.data}');

      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('[OrderService] Get Order Details Error: ${e.message}');
      debugPrint('[OrderService] Error Response: ${e.response?.data}');
      throw ApiException.fromDioException(e);
    }
  }

  /// Get driver's order history
  Future<List<OrderModel>> getOrderHistory({int page = 1}) async {
    try {
      debugPrint('[OrderService] === GET ORDER HISTORY REQUEST ===');
      debugPrint('[OrderService] Endpoint: /orders/');
      debugPrint('[OrderService] Query: {page: $page}');

      final response = await _apiClient.get(
        '/orders/',
        queryParameters: {'page': page},
      );

      debugPrint('[OrderService] === GET ORDER HISTORY RESPONSE ===');
      debugPrint('[OrderService] Status: ${response.statusCode}');
      debugPrint('[OrderService] Data: ${response.data}');

      final List<OrderModel> orders = [];

      if (response.data is Map && response.data['results'] != null) {
        for (final json in response.data['results']) {
          orders.add(OrderModel.fromJson(json));
        }
      } else if (response.data is List) {
        for (final json in response.data) {
          orders.add(OrderModel.fromJson(json));
        }
      }

      debugPrint('[OrderService] Parsed ${orders.length} orders from history');
      return orders;
    } on DioException catch (e) {
      debugPrint('[OrderService] Get Order History Error: ${e.message}');
      debugPrint('[OrderService] Error Response: ${e.response?.data}');
      throw ApiException.fromDioException(e);
    }
  }

  /// Get active order (if any)
  Future<OrderModel?> getActiveOrder() async {
    try {
      debugPrint('[OrderService] === GET ACTIVE ORDER ===');
      // Get orders and find one that's in progress
      final orders = await getOrderHistory();

      final activeStatuses = [
        OrderStatus.accepted,
        OrderStatus.onTheWay,
        OrderStatus.delivered,
      ];

      for (final order in orders) {
        if (activeStatuses.contains(order.status)) {
          debugPrint('[OrderService] Found active order: ${order.id} with status ${order.status}');
          return order;
        }
      }

      debugPrint('[OrderService] No active order found');
      return null;
    } catch (e) {
      debugPrint('[OrderService] Get Active Order Error: $e');
      return null;
    }
  }
}
