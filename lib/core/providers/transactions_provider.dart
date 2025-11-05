import 'package:flutter/foundation.dart';

import '../../models/enums/transaction_categories.dart';
import '../../models/enums/transaction_type.dart';
import '../../models/transaction_model.dart';

class TransactionsProvider extends ChangeNotifier {
  final List<TransactionModel> _transactions = [
    TransactionModel(
      id: '1',
      userId: '2',
      category: TransactionCategory.food,
      type: TransactionType.payment,
      amount: 45.50,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      title: 'Almoço',
      description: 'Almoço no restaurante perto do trabalho',
    ),
    TransactionModel(
      id: '2',
      userId: '2',
      category: TransactionCategory.health,
      type: TransactionType.payment,
      amount: 120.00,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      title: 'Medicamentos',
      description: 'Compra de remédios na farmácia',
    ),
    TransactionModel(
      id: '3',
      userId: '2',
      category: TransactionCategory.leisure,
      type: TransactionType.payment,
      amount: 320.00,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      title: 'Cinema',
      description: 'Sessão de cinema com amigos',
    ),
    TransactionModel(
      id: '4',
      userId: '2',
      category: TransactionCategory.other,
      type: TransactionType.income,
      amount: 5000.00,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      title: 'Salário',
      description: 'Recebimento mensal do salário',
    ),
    TransactionModel(
      id: '5',
      userId: '2',
      category: TransactionCategory.transport,
      type: TransactionType.payment,
      amount: 75.25,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      title: 'Uber',
      description: 'Corrida de Uber para o centro',
    ),
  ];

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }
}
