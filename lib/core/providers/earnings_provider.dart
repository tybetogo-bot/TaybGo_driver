import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../services/earnings_service.dart';
import '../../features/earnings/models/earnings_model.dart';

class EarningsProvider extends ChangeNotifier {
  int _stateGeneration = 0;

  final EarningsService _earningsService;

  EarningsProvider({EarningsService? earningsService, ApiClient? apiClient})
    : _earningsService =
          earningsService ??
          EarningsService(apiClient: apiClient ?? ApiClient());

  EarningsResponse? _earningsResponse;
  EarningsResponse? get earningsResponse => _earningsResponse;

  EarningsSummary? get summary => _earningsResponse?.summary;
  List<EarningEntry> get entries => _earningsResponse?.results ?? [];
  int get totalCount => _earningsResponse?.count ?? 0;
  bool get hasMore => _earningsResponse?.next != null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Current filter state
  String? _fromDate;
  String? _toDate;
  String? _orderType;
  String? _paymentType;

  Future<void> fetchEarnings({
    String? from,
    String? to,
    String? orderType,
    String? paymentType,
    int? page,
    int? pageSize,
  }) async {
    final generation = _stateGeneration;
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Store filters
    _fromDate = from;
    _toDate = to;
    _orderType = orderType;
    _paymentType = paymentType;

    try {
      final loadedEarnings = await _earningsService.getEarnings(
        from: from,
        to: to,
        orderType: orderType,
        paymentType: paymentType,
        ordering: '-earned_at',
        page: page,
        pageSize: pageSize,
      );
      if (generation != _stateGeneration) return;
      _earningsResponse = loadedEarnings;
      _error = null;
    } catch (e) {
      if (generation != _stateGeneration) return;
      _error = e.toString();
      debugPrint('[EarningsProvider] Error: $e');
    } finally {
      if (generation == _stateGeneration) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Refresh with current filters
  Future<void> refresh() async {
    final generation = _stateGeneration;
    await fetchEarnings(
      from: _fromDate,
      to: _toDate,
      orderType: _orderType,
      paymentType: _paymentType,
    );
    if (generation != _stateGeneration) return;
  }

  void clearAll() {
    ++_stateGeneration;
    _earningsResponse = null;
    _isLoading = false;
    _error = null;
    _fromDate = null;
    _toDate = null;
    _orderType = null;
    _paymentType = null;
    notifyListeners();
  }

  @override
  void dispose() {
    ++_stateGeneration;
    super.dispose();
  }
}
