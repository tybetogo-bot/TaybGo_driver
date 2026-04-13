import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../services/earnings_service.dart';
import '../../features/earnings/models/earnings_model.dart';

class EarningsProvider extends ChangeNotifier {
  final EarningsService _earningsService;

  EarningsProvider({EarningsService? earningsService, ApiClient? apiClient})
      : _earningsService = earningsService ??
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
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Store filters
    _fromDate = from;
    _toDate = to;
    _orderType = orderType;
    _paymentType = paymentType;

    try {
      _earningsResponse = await _earningsService.getEarnings(
        from: from,
        to: to,
        orderType: orderType,
        paymentType: paymentType,
        ordering: '-earned_at',
        page: page,
        pageSize: pageSize,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('[EarningsProvider] Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh with current filters
  Future<void> refresh() async {
    await fetchEarnings(
      from: _fromDate,
      to: _toDate,
      orderType: _orderType,
      paymentType: _paymentType,
    );
  }

  void clearAll() {
    _earningsResponse = null;
    _isLoading = false;
    _error = null;
    _fromDate = null;
    _toDate = null;
    _orderType = null;
    _paymentType = null;
    notifyListeners();
  }
}
