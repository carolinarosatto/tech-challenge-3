import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tech_challenge_3/core/errors/error_handler.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transactions_filter_entity.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/calculate_totals_usecase.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/filter_transactions_usecase.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/save_transaction_usecase.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/watch_transactions_page_usecase.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/watch_transactions_usecase.dart';
import 'package:tech_challenge_3/features/transactions/presentation/providers/transactions_pagination_controller.dart';
import 'package:tech_challenge_3/features/transactions/presentation/providers/transactions_provider_coordinator.dart';

class TransactionsProvider extends ChangeNotifier {
  TransactionsProvider({
    required this.userId,
    required WatchTransactionsUseCase watchTransactionsUseCase,
    required WatchTransactionsPageUseCase watchTransactionsPageUseCase,
    required SaveTransactionUseCase saveTransactionUseCase,
    required DeleteTransactionUseCase deleteTransactionUseCase,
    required CalculateTotalsUseCase calculateTotalsUseCase,
    FilterTransactionsUseCase? filterTransactionsUseCase,
    TransactionsPaginationController? paginationController,
  }) : _watchTransactionsUseCase = watchTransactionsUseCase,
       _watchTransactionsPageUseCase = watchTransactionsPageUseCase,
       _saveTransactionUseCase = saveTransactionUseCase,
       _deleteTransactionUseCase = deleteTransactionUseCase,
       _calculateTotalsUseCase = calculateTotalsUseCase,
       _filterTransactionsUseCase =
           filterTransactionsUseCase ?? const FilterTransactionsUseCase(),
       _paginationController =
           paginationController ?? TransactionsPaginationController() {
    _coordinator = TransactionsProviderCoordinator(
      userId: userId,
      watchTransactionsPageUseCase: _watchTransactionsPageUseCase,
      paginationController: _paginationController,
      getFilters: () => _filters,
      setFilters: (filters) => _filters = filters,
      getPagedFilteredTransactions: () => pagedFilteredTransactions,
      setPagedTransactions: (items) => _pagedTransactions = items,
      clearPagedFilteredCache: () => _cachedPagedFilteredTransactions = null,
      setError: _setError,
      notifyListeners: notifyListeners,
    );
    _init();
  }

  final String userId;
  final WatchTransactionsUseCase _watchTransactionsUseCase;
  final WatchTransactionsPageUseCase _watchTransactionsPageUseCase;
  final SaveTransactionUseCase _saveTransactionUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;
  final CalculateTotalsUseCase _calculateTotalsUseCase;
  final FilterTransactionsUseCase _filterTransactionsUseCase;
  final TransactionsPaginationController _paginationController;
  late final TransactionsProviderCoordinator _coordinator;

  StreamSubscription<List<TransactionEntity>>? _subscription;

  bool _isLoading = true;
  List<TransactionEntity> _allTransactions = [];
  List<TransactionEntity> _pagedTransactions = [];
  TransactionsFilterEntity _filters = TransactionsFilterEntity.empty;
  String? _errorMessage;

  List<TransactionEntity>? _cachedPagedFilteredTransactions;
  TransactionsTotals? _cachedTotals;

  bool get isLoading => _isLoading;
  bool get isLoadingPage => _paginationController.isLoadingPage;
  bool get hasMore => _paginationController.hasMore;
  int get pageSize => _paginationController.pageSize;
  String? get errorMessage => _errorMessage;

  TransactionsFilterEntity get filters => _filters;
  bool get hasActiveFilters => _filters.hasFilters;

  List<TransactionEntity> get transactions =>
      List.unmodifiable(_allTransactions);

  List<TransactionEntity> get filteredTransactions => _filterTransactionsUseCase
      .execute(transactions: _allTransactions, filters: _filters);

  List<TransactionEntity> get pagedFilteredTransactions {
    _cachedPagedFilteredTransactions ??= _filterTransactionsUseCase.execute(
      transactions: _pagedTransactions,
      filters: _filters,
    );
    return _cachedPagedFilteredTransactions!;
  }

  Map<TransactionCategory, double> get totalsByCategory => _totals.byCategory;
  double get totalIncome => _totals.totalIncome;
  double get totalOutcome => _totals.totalOutcome;
  double get balance => _totals.balance;

  void _init() {
    _subscription = _watchTransactionsUseCase
        .execute(userId: userId)
        .listen(
          (items) {
            _allTransactions = items;
            _cachedTotals = null;
            _isLoading = false;
            notifyListeners();
          },
          onError: (Object error) {
            _setError('Erro ao carregar transações.');
            _isLoading = false;
            notifyListeners();
          },
        );

    _coordinator.subscribePagedTransactions(reset: true);
  }

  void updateFilters(TransactionsFilterEntity filters) =>
      _coordinator.updateFilters(filters);

  void clearFilters() => _coordinator.clearFilters();

  void loadMore() => _coordinator.loadMore();

  void updatePageSize(int pageSize) => _coordinator.updatePageSize(pageSize);

  void updatePageSizeForViewport({
    required double viewportHeight,
    required double estimatedItemHeight,
    required double listBottomPadding,
  }) => _coordinator.updatePageSizeForViewport(
    viewportHeight: viewportHeight,
    estimatedItemHeight: estimatedItemHeight,
    listBottomPadding: listBottomPadding,
  );

  @override
  void dispose() {
    _subscription?.cancel();
    _coordinator.dispose();
    _paginationController.dispose();
    super.dispose();
  }

  Future<bool> saveTransaction({
    required TransactionEntity transaction,
    Uint8List? imageBytes,
  }) async {
    _clearError();

    final result = await _saveTransactionUseCase.execute(
      userId: userId,
      transaction: transaction,
      imageBytes: imageBytes,
    );

    return result.fold(
      onSuccess: (_) => true,
      onFailure: (failure) {
        _setError(ErrorHandler.toMessage(failure));
        return false;
      },
    );
  }

  Future<void> deleteTransaction(String transactionId) async {
    _clearError();

    final result = await _deleteTransactionUseCase.execute(
      userId: userId,
      transactionId: transactionId,
    );

    result.fold(
      onSuccess: (_) {},
      onFailure: (failure) {
        _setError(ErrorHandler.toMessage(failure));
      },
    );
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  TransactionsTotals get _totals {
    _cachedTotals ??= _calculateTotalsUseCase.execute(_allTransactions);
    return _cachedTotals!;
  }

  void _clearError() {
    _errorMessage = null;
  }

  void _setError(String message) {
    _errorMessage = message;
  }
}
