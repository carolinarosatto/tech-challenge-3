import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tech_challenge_3/core/providers/transactions_provider.dart';
import 'package:tech_challenge_3/views/pages/create_transaction_page.dart';
import 'package:tech_challenge_3/views/widgets/empty_transactions.dart';
import 'package:tech_challenge_3/views/widgets/transaction_widget.dart';
import 'package:tech_challenge_3/views/widgets/transactions_filters/filter_not_found.dart';

class TransactionListWidget extends StatefulWidget {
  const TransactionListWidget({super.key});

  @override
  State<TransactionListWidget> createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  static const double _estimatedItemHeight = 104;
  static const double _scrollThreshold = 200;
  static const double _listBottomPadding = 80;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.userScrollDirection == ScrollDirection.idle) return;
    if (position.extentAfter <= _scrollThreshold) {
      final provider = context.read<TransactionsProvider?>();
      provider?.loadMore();
    }
  }

  void _schedulePageSizeUpdate(
    TransactionsProvider provider,
    double viewportHeight,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final currentProvider = context.read<TransactionsProvider?>();
      currentProvider?.updatePageSizeForViewport(
        viewportHeight: viewportHeight,
        estimatedItemHeight: _estimatedItemHeight,
        listBottomPadding: _listBottomPadding,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsProvider?>(
      builder: (context, provider, child) {
        if (provider == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final transactions = provider.pagedFilteredTransactions;

        if (provider.isLoadingPage && transactions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (transactions.isEmpty) {
          if (provider.hasActiveFilters) {
            return FilterNotFound(onClear: provider.clearFilters);
          }
          return const EmptyTransactions();
        }

        final showLoadingMore = provider.isLoadingPage;

        return LayoutBuilder(
          builder: (context, constraints) {
            _schedulePageSizeUpdate(provider, constraints.maxHeight);

            return ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: _listBottomPadding),
              itemCount: transactions.length + (showLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (showLoadingMore && index == transactions.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final transaction = transactions[index];

                return GestureDetector(
                  onTap: () {
                    CreateTransactionPage.show(
                      context,
                      transaction: transaction,
                    );
                  },
                  child: TransactionWidget(transaction: transaction),
                );
              },
            );
          },
        );
      },
    );
  }
}
