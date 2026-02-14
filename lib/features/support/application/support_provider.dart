import 'package:flutter/foundation.dart';
import '../../../core/api/api_client.dart';
import '../data/models/support_ticket_model.dart';
import '../data/repositories/support_repository.dart';

class SupportProvider extends ChangeNotifier {
  final SupportRepository _repository;

  SupportProvider({SupportRepository? repository, ApiClient? apiClient})
      : _repository = repository ??
            SupportRepository(apiClient: apiClient ?? ApiClient());

  // Ticket list
  List<SupportTicket> _tickets = [];
  List<SupportTicket> get tickets => List.unmodifiable(_tickets);

  // Filter
  TicketStatus? _statusFilter;
  TicketStatus? get statusFilter => _statusFilter;

  // Pagination
  int _currentPage = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  bool _isSending = false;
  bool get isSending => _isSending;

  // Current ticket detail
  SupportTicket? _currentTicket;
  SupportTicket? get currentTicket => _currentTicket;

  bool _isLoadingDetail = false;
  bool get isLoadingDetail => _isLoadingDetail;

  // Error
  String? _error;
  String? get error => _error;

  /// Set status filter and reload tickets
  void setStatusFilter(TicketStatus? status) {
    if (_statusFilter == status) return;
    _statusFilter = status;
    fetchTickets();
  }

  /// Fetch tickets (first page)
  Future<void> fetchTickets() async {
    _isLoading = true;
    _error = null;
    _currentPage = 1;
    notifyListeners();

    try {
      final result = await _repository.getTickets(
        page: 1,
        status: _statusFilter,
      );
      _tickets = result.tickets;
      _hasMore = result.hasMore;
      _currentPage = 1;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load next page of tickets
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final result = await _repository.getTickets(
        page: nextPage,
        status: _statusFilter,
      );
      _tickets = [..._tickets, ...result.tickets];
      _hasMore = result.hasMore;
      _currentPage = nextPage;
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Create a new ticket
  Future<SupportTicket?> createTicket({
    required String subject,
    required TicketCategory category,
    required TicketPriority priority,
    required String message,
    int? orderId,
  }) async {
    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      final ticket = await _repository.createTicket(
        subject: subject,
        category: category,
        priority: priority,
        message: message,
        orderId: orderId,
      );
      _tickets.insert(0, ticket);
      _isCreating = false;
      notifyListeners();
      return ticket;
    } catch (e) {
      _error = e.toString();
      _isCreating = false;
      notifyListeners();
      return null;
    }
  }

  /// Fetch ticket detail with messages
  Future<void> fetchTicketDetail(int ticketId) async {
    _isLoadingDetail = true;
    _error = null;
    notifyListeners();

    try {
      _currentTicket = await _repository.getTicketDetail(ticketId);
      _isLoadingDetail = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  /// Send a message on the current ticket
  Future<bool> sendMessage(String body) async {
    if (_currentTicket == null) return false;

    _isSending = true;
    notifyListeners();

    try {
      final message = await _repository.sendMessage(_currentTicket!.id, body);

      // Update current ticket with new message
      final updatedMessages = [..._currentTicket!.messages, message];
      _currentTicket = SupportTicket(
        id: _currentTicket!.id,
        subject: _currentTicket!.subject,
        category: _currentTicket!.category,
        priority: _currentTicket!.priority,
        status: _currentTicket!.status,
        orderId: _currentTicket!.orderId,
        orderDisplay: _currentTicket!.orderDisplay,
        createdAt: _currentTicket!.createdAt,
        updatedAt: DateTime.now(),
        messages: updatedMessages,
      );

      _isSending = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSending = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearCurrentTicket() {
    _currentTicket = null;
  }
}
