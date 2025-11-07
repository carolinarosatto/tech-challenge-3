import 'package:flutter/material.dart';
import 'package:tech_challenge_3/views/widgets/transaction_list_widget.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: TransactionListWidget());
  }
}
