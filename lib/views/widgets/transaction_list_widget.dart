import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_challenge_3/models/transaction_model.dart';
import '../../core/providers/transactions_provider.dart';
import 'transaction_widget.dart';

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = context
        .select<TransactionsProvider, List<TransactionModel>>(
          (value) => value.transactions,
        );

    if (transactions.isEmpty) {
      return const Center(child: Text('Nenhuma transação disponível.'));
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionWidget(transaction: transaction);
      },
    );
  }
}
