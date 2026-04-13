import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../../features/earnings/models/earnings_model.dart';

class EarningsService {
  final ApiClient _apiClient;

  EarningsService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<EarningsResponse> getEarnings({
    String? from,
    String? to,
    String? orderType,
    String? paymentType,
    String? ordering,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, dynamic>{};
    if (from != null) queryParams['from'] = from;
    if (to != null) queryParams['to'] = to;
    if (orderType != null) queryParams['order_type'] = orderType;
    if (paymentType != null) queryParams['payment_type'] = paymentType;
    if (ordering != null) queryParams['ordering'] = ordering;
    if (page != null) queryParams['page'] = page;
    if (pageSize != null) queryParams['page_size'] = pageSize;

    try {
      final response = await _apiClient.get(
        ApiConstants.driverEarnings,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return EarningsResponse.fromJson(data);
      }

      debugPrint('[EarningsService] Unexpected response type: ${data.runtimeType}');
      return EarningsResponse(
        count: 0,
        summary: EarningsSummary(
          totalOrders: 0,
          totalEarnings: 0,
          totalDeliveryFees: 0,
          totalTips: 0,
        ),
        results: [],
      );
    } catch (e) {
      debugPrint('[EarningsService] Error fetching earnings: $e');
      rethrow;
    }
  }
}
