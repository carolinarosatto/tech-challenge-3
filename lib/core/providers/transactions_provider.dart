import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tech_challenge_3/core/services/transaction_service.dart';

import '../../models/enums/transaction_categories.dart';
import '../../models/enums/transaction_type.dart';
import '../../models/transaction_model.dart';
import '../../models/transactions_filter.dart';

class TransactionsProvider extends ChangeNotifier {
  final TransactionService _service;
  final String userId;
  StreamSubscription? _subscription;
  StreamSubscription? _pagedSubscription;

  int _pageSize = 6;
  static const Duration _minLoadingIndicatorDuration = Duration(
    milliseconds: 250,
  );
  bool _isLoading = true;
  bool _isLoadingPage = false;
  bool _hasMore = true;
  List<TransactionModel> _allTransactions = [];
  List<TransactionModel> _pagedTransactions = [];
  TransactionsFilter _filters = TransactionsFilter.empty;
  late int _currentLimit = _pageSize;
  DateTime? _pageLoadStartedAt;
  int _pageLoadToken = 0;
  bool _isDisposed = false;

  TransactionsProvider({required this.userId})
    : _service = TransactionService(userId: userId) {
    _init();
  }

  bool get isLoading => _isLoading;
  bool get isLoadingPage => _isLoadingPage;
  TransactionsFilter get filters => _filters;
  bool get hasActiveFilters => _filters.hasFilters;
  bool get hasMore => _hasMore;
  int get pageSize => _pageSize;

  void _init() {
    _subscription = _service.getTransactions().listen(
      (items) {
        _allTransactions = items;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        if (kDebugMode) {
          print("Erro no stream de transações: $error");
        }
        _isLoading = false;
        notifyListeners();
      },
    );
    _subscribePagedTransactions(reset: true);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _subscription?.cancel();
    _pagedSubscription?.cancel();
    super.dispose();
  }

  List<TransactionModel> get transactions =>
      List.unmodifiable(_allTransactions);
  List<TransactionModel> get filteredTransactions =>
      List.unmodifiable(_allTransactions.where(_matchesFilters));
  List<TransactionModel> get pagedFilteredTransactions =>
      List.unmodifiable(_pagedTransactions.where(_matchesFilters));

  Map<TransactionCategory, double> get totalsByCategory =>
      _getTotalsByCategory();

  Map<TransactionCategory, double> _getTotalsByCategory() {
    final totals = <TransactionCategory, double>{};

    for (final transaction in _allTransactions) {
      if (transaction.type.direction != TransactionDirection.expense) continue;

      final amount = transaction.amount.abs();
      totals.update(
        transaction.category,
        (value) => value + amount,
        ifAbsent: () => amount,
      );
    }
    return Map.unmodifiable(totals);
  }

  double get totalIncome => _allTransactions
      .where((t) => t.type.direction == TransactionDirection.income)
      .fold<double>(0, (sum, t) => sum + t.amount.abs());

  double get totalOutcome => _allTransactions
      .where((t) => t.type.direction == TransactionDirection.expense)
      .fold<double>(0, (sum, t) => sum + t.amount.abs());

  double get balance => totalIncome - totalOutcome;

  void addTransaction(TransactionModel transaction) {
    _service.saveTransaction(transaction: transaction);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _service.deleteTransaction(transactionId);
  }

  void updateFilters(TransactionsFilter filters) {
    _filters = filters;
    _subscribePagedTransactions(reset: true);
    notifyListeners();
  }

  void clearFilters() {
    if (!_filters.hasFilters) return;
    _filters = TransactionsFilter.empty;
    _subscribePagedTransactions(reset: true);
    notifyListeners();
  }

  void loadMore() {
    if (_isLoadingPage || !_hasMore) return;
    _currentLimit += _pageSize;
    _subscribePagedTransactions();
  }

  void updatePageSize(int pageSize) {
    if (pageSize <= 0 || pageSize == _pageSize) return;
    _pageSize = pageSize;
    _subscribePagedTransactions(reset: true);
  }

  void updatePageSizeForViewport({
    required double viewportHeight,
    required double estimatedItemHeight,
    required double listBottomPadding,
  }) {
    final availableHeight = viewportHeight - listBottomPadding;
    final estimatedCount = availableHeight <= 0
        ? 1
        : (availableHeight / estimatedItemHeight).ceil();
    final pageSize = estimatedCount < 1 ? 1 : estimatedCount;
    updatePageSize(pageSize);
  }

  void _subscribePagedTransactions({bool reset = false}) {
    if (reset) {
      _currentLimit = _pageSize;
      _hasMore = true;
      _pagedTransactions = [];
    }
    _pagedSubscription?.cancel();
    _isLoadingPage = true;
    _pageLoadStartedAt = DateTime.now();
    _pageLoadToken += 1;
    final currentToken = _pageLoadToken;
    notifyListeners();
    _pagedSubscription = _service
        .getTransactionsPage(limit: _currentLimit)
        .listen(
          (items) {
            _pagedTransactions = items;
            _hasMore = items.length >= _currentLimit;
            notifyListeners();
            _finishPageLoad(currentToken);
          },
          onError: (error) {
            _isLoadingPage = false;
            _hasMore = false;
            notifyListeners();
          },
        );
  }

  void _finishPageLoad(int token) {
    final startedAt = _pageLoadStartedAt;
    final elapsed = startedAt == null
        ? Duration.zero
        : DateTime.now().difference(startedAt);
    final remaining = _minLoadingIndicatorDuration - elapsed;
    if (remaining > Duration.zero) {
      Future.delayed(remaining, () {
        if (_isDisposed || _pageLoadToken != token) return;
        _isLoadingPage = false;
        notifyListeners();
        _maybeLoadMoreForFilters();
      });
    } else {
      if (_isDisposed) return;
      _isLoadingPage = false;
      notifyListeners();
      _maybeLoadMoreForFilters();
    }
  }

  void _maybeLoadMoreForFilters() {
    if (!_filters.hasFilters) return;
    if (pagedFilteredTransactions.isNotEmpty) return;
    if (!_hasMore || _isLoadingPage) return;
    loadMore();
  }

  bool _matchesFilters(TransactionModel transaction) {
    if (!_filters.hasFilters) return true;

    if (_filters.direction != null &&
        transaction.type.direction != _filters.direction) {
      return false;
    }

    if (_filters.types.isNotEmpty &&
        !_filters.types.contains(transaction.type)) {
      return false;
    }

    if (_filters.categories.isNotEmpty &&
        !_filters.categories.contains(transaction.category)) {
      return false;
    }

    return true;
  }
}
