import 'package:flutter/material.dart';

import '../../models/enums/transaction_categories.dart';
import '../../models/enums/transaction_type.dart';
import '../../models/transaction_model.dart';
import 'transaction_widget.dart';

class TransactionListWidget extends StatelessWidget {
  TransactionListWidget({super.key});

  final List<TransactionModel> mockTransactions = [
    TransactionModel(
      id: '1',
      userId: '2',
      category: TransactionCategory.food,
      type: TransactionType.payment,
      amount: 45.50,
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      title: 'Almoço',
      description: 'Almoço no restaurante perto do trabalho',
    ),
    TransactionModel(
      id: '2',
      userId: '2',
      category: TransactionCategory.health,
      type: TransactionType.payment,
      amount: 120.00,
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      title: 'Medicamentos',
      description: 'Compra de remédios na farmácia',
    ),
    TransactionModel(
      id: '3',
      userId: '2',
      category: TransactionCategory.leisure,
      type: TransactionType.payment,
      amount: 320.00,
      createdAt: DateTime.now().subtract(Duration(days: 5)),
      title: 'Cinema',
      description: 'Sessão de cinema com amigos',
    ),
    TransactionModel(
      id: '4',
      userId: '2',
      category: TransactionCategory.other,
      type: TransactionType.income,
      amount: 5000.00,
      createdAt: DateTime.now().subtract(Duration(days: 10)),
      title: 'Salário',
      description: 'Recebimento mensal do salário',
    ),
    TransactionModel(
      id: '5',
      userId: '2',
      category: TransactionCategory.transport,
      type: TransactionType.payment,
      amount: 75.25,
      createdAt: DateTime.now().subtract(Duration(hours: 12)),
      title: 'Uber',
      description: 'Corrida de Uber para o centro',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mockTransactions.length,
      itemBuilder: (context, index) {
        final transaction = mockTransactions[index];
        return TransactionWidget(transaction: transaction);
      },
    );
  }
}
