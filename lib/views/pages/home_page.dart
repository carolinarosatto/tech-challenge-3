import 'package:flutter/material.dart';
import 'package:tech_challenge_3/views/widgets/transaction_list_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: TransactionListWidget()));
  }
}
