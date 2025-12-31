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

  bool _isLoading = true;
  List<TransactionModel> _transactions = [];
  TransactionsFilter _filters = TransactionsFilter.empty;

  TransactionsProvider({required this.userId})
    : _service = TransactionService(userId: userId) {
    _init();
  }

  bool get isLoading => _isLoading;
  TransactionsFilter get filters => _filters;
  bool get hasActiveFilters => _filters.hasFilters;

  void _init() {
    _subscription = _service.getTransactions().listen(
      (items) {
        _transactions = items;
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
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  List<TransactionModel> get filteredTransactions =>
      List.unmodifiable(_transactions.where(_matchesFilters));

  Map<TransactionCategory, double> get totalsByCategory =>
      _getTotalsByCategory();

  Map<TransactionCategory, double> _getTotalsByCategory() {
    final totals = <TransactionCategory, double>{};

    for (final transaction in _transactions) {
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

  double get totalIncome => _transactions
      .where((t) => t.type.direction == TransactionDirection.income)
      .fold<double>(0, (sum, t) => sum + t.amount.abs());

  double get totalOutcome => _transactions
      .where((t) => t.type.direction == TransactionDirection.expense)
      .fold<double>(0, (sum, t) => sum + t.amount.abs());

  void addTransaction(TransactionModel transaction) {
    _service.saveTransaction(transaction: transaction);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _service.deleteTransaction(transactionId);
  }

  void updateFilters(TransactionsFilter filters) {
    _filters = filters;
    notifyListeners();
  }

  void clearFilters() {
    if (!_filters.hasFilters) return;
    _filters = TransactionsFilter.empty;
    notifyListeners();
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
