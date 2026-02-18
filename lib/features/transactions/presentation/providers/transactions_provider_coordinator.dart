import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transactions_filter_entity.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/watch_transactions_page_usecase.dart';
import 'package:tech_challenge_3/features/transactions/presentation/providers/transactions_pagination_controller.dart';

class TransactionsProviderCoordinator {
  TransactionsProviderCoordinator({
    required this.userId,
    required this.watchTransactionsPageUseCase,
    required this.paginationController,
    required this.getFilters,
    required this.setFilters,
    required this.getPagedFilteredTransactions,
    required this.setPagedTransactions,
    required this.clearPagedFilteredCache,
    required this.setError,
    required this.notifyListeners,
  });

  final String userId;
  final WatchTransactionsPageUseCase watchTransactionsPageUseCase;
  final TransactionsPaginationController paginationController;
  final TransactionsFilterEntity Function() getFilters;
  final void Function(TransactionsFilterEntity filters) setFilters;
  final List<TransactionEntity> Function() getPagedFilteredTransactions;
  final void Function(List<TransactionEntity> items) setPagedTransactions;
  final VoidCallback clearPagedFilteredCache;
  final void Function(String message) setError;
  final VoidCallback notifyListeners;

  StreamSubscription<List<TransactionEntity>>? _pagedSubscription;

  void updateFilters(TransactionsFilterEntity filters) {
    setFilters(filters);
    clearPagedFilteredCache();
    subscribePagedTransactions(reset: true);
    notifyListeners();
  }

  void clearFilters() {
    if (!getFilters().hasFilters) {
      return;
    }

    setFilters(TransactionsFilterEntity.empty);
    clearPagedFilteredCache();
    subscribePagedTransactions(reset: true);
    notifyListeners();
  }

  void loadMore() {
    if (!paginationController.canLoadMore) {
      return;
    }

    paginationController.expandPage();
    subscribePagedTransactions();
  }

  void updatePageSize(int pageSize) {
    final changed = paginationController.updatePageSize(pageSize);
    if (!changed) {
      return;
    }

    subscribePagedTransactions(reset: true);
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
    final newPageSize = estimatedCount < 1 ? 1 : estimatedCount;
    updatePageSize(newPageSize);
  }

  void subscribePagedTransactions({bool reset = false}) {
    if (reset) {
      paginationController.reset();
      setPagedTransactions([]);
    }

    _pagedSubscription?.cancel();
    final token = paginationController.startLoading();
    notifyListeners();

    _pagedSubscription = watchTransactionsPageUseCase
        .execute(userId: userId, limit: paginationController.currentLimit)
        .listen(
          (items) {
            setPagedTransactions(items);
            clearPagedFilteredCache();
            paginationController.markDataLoaded(items.length);
            notifyListeners();
            _finishPageLoad(token);
          },
          onError: (Object error) {
            paginationController.markError();
            setError('Erro ao carregar página de transações.');
            notifyListeners();
          },
        );
  }

  void _finishPageLoad(int token) {
    paginationController.finishLoading(
      token: token,
      onCompleted: () {
        notifyListeners();
        _maybeLoadMoreForFilters();
      },
    );
  }

  void _maybeLoadMoreForFilters() {
    if (!getFilters().hasFilters) {
      return;
    }
    if (getPagedFilteredTransactions().isNotEmpty) {
      return;
    }
    if (!paginationController.canLoadMore) {
      return;
    }

    loadMore();
  }

  void dispose() {
    _pagedSubscription?.cancel();
  }
}
