import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../../features/orders/models/order_model.dart';

class OrderService {
  final ApiClient _apiClient;

  OrderService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Helper to print large JSON objects in chunks (debugPrint truncates at ~1000 chars)
  void _printFullJson(String prefix, dynamic data) {
    try {
      final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
      final lines = jsonStr.split('\n');
      debugPrint('$prefix ▼▼▼ FULL JSON START ▼▼▼');
      for (final line in lines) {
        debugPrint('$prefix $line');
      }
      debugPrint('$prefix ▲▲▲ FULL JSON END ▲▲▲');
    } catch (e) {
      debugPrint('$prefix Failed to pretty print JSON: $e');
      debugPrint('$prefix Raw: $data');
    }
  }

  /// Fetch suggested orders available for the driver
  Future<List<OrderModel>> getSuggestedOrders() async {
    try {
      debugPrint('[OrderService] === GET SUGGESTED ORDERS REQUEST ===');
      debugPrint('[OrderService] Endpoint: ${ApiConstants.suggestedOrders}');

      final response = await _apiClient.get(ApiConstants.suggestedOrders);

      debugPrint('[OrderService] === GET SUGGESTED ORDERS RESPONSE ===');
      debugPrint('[OrderService] Status: ${response.statusCode}');
      debugPrint('[OrderService] Response type: ${response.data.runtimeType}');
      debugPrint('[OrderService] RAW RESPONSE: ${response.data}');
      _printFullJson('[OrderService]', response.data);

      final List<OrderModel> orders = [];

      // Handle paginated response
      if (response.data is Map && response.data['results'] != null) {
        final results = response.data['results'] as List;
        debugPrint(
          '[OrderService] Found ${results.length} orders in "results"',
        );
        if (results.isEmpty) {
          debugPrint(
            '[OrderService] Results array is EMPTY - no suggested orders available from API',
          );
        }
        for (int i = 0; i < results.length; i++) {
          final json = results[i];
          debugPrint('[OrderService] *** ORDER $i RAW DATA ***');
          _printFullJson('[OrderService]', json);
          // Log items specifically
          _logItemsField(json, i);
          orders.add(OrderModel.fromJson(json));
        }
      } else if (response.data is List) {
        final dataList = response.data as List;
        debugPrint('[OrderService] Found ${dataList.length} orders in array');
        if (dataList.isEmpty) {
          debugPrint(
            '[OrderService] Data array is EMPTY - no suggested orders available from API',
          );
        }
        for (int i = 0; i < dataList.length; i++) {
          final json = dataList[i];
          debugPrint('[OrderService] *** ORDER $i RAW DATA ***');
          _printFullJson('[OrderService]', json);
          _logItemsField(json, i);
          orders.add(OrderModel.fromJson(json));
        }
      } else {
        debugPrint(
          '[OrderService] UNEXPECTED RESPONSE FORMAT: ${response.data}',
        );
      }

      debugPrint(
        '[OrderService] === SUGGESTED ORDERS RESULT: ${orders.length} orders ===',
      );
      return orders;
    } on DioException catch (e) {
      debugPrint('[OrderService] Get Suggested Orders Error: ${e.message}');
      debugPrint('[OrderService] Error Response: ${e.response?.data}');
      throw ApiException.fromDioException(e);
    }
  }

  /// Log items field specifically for debugging
  void _logItemsField(Map<String, dynamic> json, int orderIndex) {
    debugPrint('[OrderService] --- ORDER $orderIndex ITEMS DEBUG ---');
    final possibleItemFields = [
      'items',
      'order_items',
      'line_items',
      'products',
    ];
    for (final field in possibleItemFields) {
      if (json[field] != null) {
        debugPrint('[OrderService] Found "$field" field:');
        if (json[field] is List) {
          final items = json[field] as List;
          debugPrint('[OrderService]   Count: ${items.length}');
          for (int j = 0; j < items.length; j++) {
            debugPrint('[OrderService]   Item $j:');
            _printFullJson('[OrderService]    ', items[j]);
          }
        } else {
          debugPrint('[OrderService]   Value: ${json[field]}');
        }
      }
    }
    debugPrint('[OrderService] --- END ITEMS DEBUG ---');
  }

  /// Accept an order - uses atomic locking on backend
  /// Throws on conflict (409), expiry (403), or not found (404)
  Future<void> acceptOrder(String orderId) async {
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
      _printFullJson('[OrderService]', response.data);

      // Success - provider will use pendingOrder data
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
        throw ApiException(message: 'Order not found', statusCode: 404);
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

  /// Drop an accepted order and return it to dispatch.
  Future<void> dropOrder(String orderId) async {
    try {
      debugPrint('[OrderService] === DROP ORDER REQUEST ===');
      debugPrint('[OrderService] Endpoint: ${ApiConstants.dropOrder}');
      debugPrint('[OrderService] Data: {order_id: $orderId}');

      final response = await _apiClient.post(
        ApiConstants.dropOrder,
        data: {'order_id': int.tryParse(orderId) ?? orderId},
      );

      debugPrint('[OrderService] === DROP ORDER RESPONSE ===');
      debugPrint('[OrderService] Status: ${response.statusCode}');
      debugPrint('[OrderService] Data: ${response.data}');
    } on DioException catch (e) {
      debugPrint('[OrderService] Drop Order Error: ${e.message}');
      debugPrint('[OrderService] Error Response: ${e.response?.data}');
      if (e.response?.statusCode == 400) {
        final detail = e.response?.data is Map
            ? e.response?.data['detail']
            : null;
        throw ApiException(
          message: detail?.toString() ?? 'Unable to drop order',
          statusCode: 400,
        );
      }
      throw ApiException.fromDioException(e);
    }
  }

  /// Update order status (ACCEPTED -> ON_THE_WAY -> DELIVERED -> COMPLETED)
  /// Returns the new status if successful, throws on error
  Future<OrderStatus> updateOrderStatus(
    String orderId,
    OrderStatus newStatus,
  ) async {
    try {
      debugPrint('[OrderService] === UPDATE ORDER STATUS REQUEST ===');
      debugPrint('[OrderService] Endpoint: ${ApiConstants.updateOrderStatus}');
      debugPrint(
        '[OrderService] Data: {order_id: $orderId, status: ${newStatus.apiValue}}',
      );

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

      // Backend returns {message, order_id, status} - just return the new status
      if (response.data is Map && response.data['status'] != null) {
        return OrderStatus.fromApi(response.data['status']);
      }

      // Fallback to the requested status if response doesn't include it
      return newStatus;
    } on DioException catch (e) {
      debugPrint('[OrderService] Update Order Status Error: ${e.message}');
      debugPrint('[OrderService] Error Response: ${e.response?.data}');
      if (e.response?.statusCode == 400) {
        final detail = e.response?.data is Map
            ? e.response?.data['detail']
            : null;
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
      debugPrint('[OrderService] *** SINGLE ORDER RAW DATA ***');
      _printFullJson('[OrderService]', response.data);

      // Log items specifically
      if (response.data is Map<String, dynamic>) {
        _logItemsField(response.data, 0);
      }

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
      _printFullJson('[OrderService]', response.data);

      final List<OrderModel> orders = [];

      if (response.data is Map && response.data['results'] != null) {
        final results = response.data['results'] as List;
        debugPrint(
          '[OrderService] Found ${results.length} orders in history "results"',
        );
        for (int i = 0; i < results.length; i++) {
          final json = results[i];
          debugPrint('[OrderService] *** HISTORY ORDER $i RAW DATA ***');
          _logItemsField(json, i);
          orders.add(OrderModel.fromJson(json));
        }
      } else if (response.data is List) {
        final dataList = response.data as List;
        debugPrint(
          '[OrderService] Found ${dataList.length} orders in history array',
        );
        for (int i = 0; i < dataList.length; i++) {
          final json = dataList[i];
          debugPrint('[OrderService] *** HISTORY ORDER $i RAW DATA ***');
          _logItemsField(json, i);
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
          debugPrint(
            '[OrderService] Found active order: ${order.id} with status ${order.status}',
          );
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
