import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../models/support_ticket_model.dart';

class SupportRepository {
  final ApiClient _apiClient;

  SupportRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Fetch paginated list of tickets
  /// Returns (tickets, hasMore)
  Future<({List<SupportTicket> tickets, bool hasMore})> getTickets({
    int page = 1,
    TicketStatus? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page};
      if (status != null) {
        queryParams['status'] = status.apiValue;
      }

      final response = await _apiClient.get(
        ApiConstants.supportTickets,
        queryParameters: queryParams,
      );

      final List<SupportTicket> tickets = [];
      bool hasMore = false;

      if (response.data is Map) {
        final results = response.data['results'] as List? ?? [];
        tickets.addAll(results.map((j) => SupportTicket.fromJson(j)));
        hasMore = response.data['next'] != null;
      } else if (response.data is List) {
        tickets.addAll(
          (response.data as List).map((j) => SupportTicket.fromJson(j)),
        );
      }

      return (tickets: tickets, hasMore: hasMore);
    } on DioException catch (e) {
      debugPrint('[SupportRepository] getTickets error: ${e.message}');
      throw ApiException.fromDioException(e);
    }
  }

  /// Create a new support ticket
  Future<SupportTicket> createTicket({
    required String subject,
    required TicketCategory category,
    required TicketPriority priority,
    required String message,
    int? orderId,
  }) async {
    try {
      final data = <String, dynamic>{
        'subject': subject,
        'category': category.apiValue,
        'priority': priority.apiValue,
        'message': message,
      };
      if (orderId != null) {
        data['order_id'] = orderId;
      }

      final response = await _apiClient.post(
        ApiConstants.supportTickets,
        data: data,
      );

      return SupportTicket.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('[SupportRepository] createTicket error: ${e.message}');
      throw ApiException.fromDioException(e);
    }
  }

  /// Get ticket detail with messages
  Future<SupportTicket> getTicketDetail(int ticketId) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.supportTicketDetail(ticketId),
      );

      return SupportTicket.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('[SupportRepository] getTicketDetail error: ${e.message}');
      throw ApiException.fromDioException(e);
    }
  }

  /// Send a message on a ticket
  Future<TicketMessage> sendMessage(int ticketId, String body) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.supportTicketMessages(ticketId),
        data: {'body': body},
      );

      return TicketMessage.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('[SupportRepository] sendMessage error: ${e.message}');
      throw ApiException.fromDioException(e);
    }
  }
}
