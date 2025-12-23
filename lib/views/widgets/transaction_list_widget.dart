import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_challenge_3/core/providers/transactions_provider.dart';
import 'package:tech_challenge_3/views/pages/create_transaction_page.dart';
import 'package:tech_challenge_3/views/widgets/empty_transactions.dart';
import 'package:tech_challenge_3/views/widgets/transaction_widget.dart';
import 'package:tech_challenge_3/views/widgets/transactions_filters/filter_not_found.dart';

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Usa Consumer para ser mais específico sobre o que observar
    return Consumer<TransactionsProvider?>(
      builder: (context, provider, child) {
        // Provider null = usuário não autenticado ou ainda inicializando
        if (provider == null) {
          return const Center(child: CircularProgressIndicator());
        }

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
      },
    );
  }
}
