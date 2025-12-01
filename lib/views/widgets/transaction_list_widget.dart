import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_challenge_3/core/providers/transactions_provider.dart';
import 'package:tech_challenge_3/views/pages/create_transaction_page.dart';
import 'transaction_widget.dart';

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
  
    final provider = context.watch<TransactionsProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.transactions.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma transação ainda.\nClique no + para adicionar.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: provider.transactions.length,
      itemBuilder: (context, index) {
        final transaction = provider.transactions[index];

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