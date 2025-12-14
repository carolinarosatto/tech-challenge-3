import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_challenge_3/core/providers/transactions_provider.dart';
import 'package:tech_challenge_3/views/pages/create_transaction_page.dart';
import 'package:tech_challenge_3/views/widgets/empty_transactions.dart';
import 'package:tech_challenge_3/views/widgets/filter_not_found.dart';
import 'transaction_widget.dart';

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionsProvider>();
    final transactions = provider.filteredTransactions;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (transactions.isEmpty) {
      if (provider.hasActiveFilters) {
        return FilterNotFound(onClear: provider.clearFilters);
      }

      return const EmptyTransactions();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];

        return GestureDetector(
          onTap: () {
            CreateTransactionPage.show(context, transaction: transaction);
          },
          child: TransactionWidget(transaction: transaction),
        );
      },
    );
  }
}
