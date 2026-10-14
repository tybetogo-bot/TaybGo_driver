import 'package:flutter/foundation.dart';
import '../../../core/api/api_client.dart';
import '../data/models/support_ticket_model.dart';
import '../data/repositories/support_repository.dart';

class SupportProvider extends ChangeNotifier {
  int _stateGeneration = 0;

  final SupportRepository _repository;

  SupportProvider({SupportRepository? repository, ApiClient? apiClient})
    : _repository =
          repository ?? SupportRepository(apiClient: apiClient ?? ApiClient());

  // Ticket list
  List<SupportTicket> _tickets = [];
  List<SupportTicket> get tickets {
    if (_statusFilter == null) return List.unmodifiable(_tickets);
    return List.unmodifiable(
      _tickets.where((t) => _matchesStatusFilter(t.status)),
    );
  }

  // Filter
  TicketStatus? _statusFilter;
  TicketStatus? get statusFilter => _statusFilter;

  bool _matchesStatusFilter(TicketStatus status) {
    switch (_statusFilter) {
      case null:
        return true;
      case TicketStatus.open:
        return status == TicketStatus.open;
      case TicketStatus.inProgress:
        return status == TicketStatus.inProgress ||
            status == TicketStatus.waitingOnCustomer;
      case TicketStatus.waitingOnCustomer:
        return status == TicketStatus.waitingOnCustomer;
      case TicketStatus.resolved:
        return status == TicketStatus.resolved;
      case TicketStatus.closed:
        return status == TicketStatus.closed || status == TicketStatus.resolved;
    }
  }

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
    final generation = _stateGeneration;
    _isLoading = true;
    _error = null;
    _currentPage = 1;
    notifyListeners();

    try {
      final result = await _repository.getTickets(
        page: 1,
        status: _statusFilter,
      );
      if (generation != _stateGeneration) return;
      _tickets = result.tickets;
      _hasMore = result.hasMore;
      _currentPage = 1;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (generation != _stateGeneration) return;
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load next page of tickets
  Future<void> loadMore() async {
    final generation = _stateGeneration;
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final result = await _repository.getTickets(
        page: nextPage,
        status: _statusFilter,
      );
      if (generation != _stateGeneration) return;
      _tickets = [..._tickets, ...result.tickets];
      _hasMore = result.hasMore;
      _currentPage = nextPage;
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      if (generation != _stateGeneration) return;
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
    final generation = _stateGeneration;
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
      if (generation != _stateGeneration) return null;
      _tickets.insert(0, ticket);
      _isCreating = false;
      notifyListeners();
      return ticket;
    } catch (e) {
      if (generation != _stateGeneration) return null;
      _error = e.toString();
      _isCreating = false;
      notifyListeners();
      return null;
    }
  }

  /// Fetch ticket detail with messages
  Future<void> fetchTicketDetail(int ticketId) async {
    final generation = _stateGeneration;
    _isLoadingDetail = true;
    _error = null;
    notifyListeners();

    try {
      final loadedTicket = await _repository.getTicketDetail(ticketId);
      if (generation != _stateGeneration) return;
      _currentTicket = loadedTicket;
      _isLoadingDetail = false;
      notifyListeners();
    } catch (e) {
      if (generation != _stateGeneration) return;
      _error = e.toString();
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  /// Send a message on the current ticket
  Future<bool> sendMessage(String body) async {
    final generation = _stateGeneration;
    if (_currentTicket == null) return false;

    _isSending = true;
    notifyListeners();

    try {
      final message = await _repository.sendMessage(_currentTicket!.id, body);
      if (generation != _stateGeneration) return false;

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
      if (generation != _stateGeneration) return false;
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

  void clearAll() {
    ++_stateGeneration;
    _tickets = [];
    _statusFilter = null;
    _currentPage = 1;
    _hasMore = true;
    _isLoading = false;
    _isLoadingMore = false;
    _isCreating = false;
    _isSending = false;
    _currentTicket = null;
    _isLoadingDetail = false;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    ++_stateGeneration;
    super.dispose();
  }
}
