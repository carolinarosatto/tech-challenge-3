import 'package:flutter/material.dart';
import 'package:tech_challenge_3/models/enums/transaction_categories.dart';
import 'package:tech_challenge_3/models/enums/transaction_type.dart';
import 'package:tech_challenge_3/models/transaction_model.dart';
import 'package:tech_challenge_3/views/widgets/transaction_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            TransactionWidget(
              transaction: TransactionModel(
                id: '1',
                userId: '2',
                category: TransactionCategory.food,
                type: TransactionType.payment,
                amount: 20.00,
                createdAt: DateTime.now(),
              ),
            ),
            TransactionWidget(
              transaction: TransactionModel(
                id: '2',
                userId: '2',
                category: TransactionCategory.health,
                type: TransactionType.income,
                amount: 20.00,
                createdAt: DateTime.now(),
              ),
            ),
            TransactionWidget(
              transaction: TransactionModel(
                id: '3',
                userId: '2',
                category: TransactionCategory.leisure,
                type: TransactionType.payment,
                amount: 24420.00,
                createdAt: DateTime.now(),
                title: 'Viagem',
                description: 'Viagem para xesquedele',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
