import 'enums/transaction_categories.dart';
import 'enums/transaction_type.dart';

class TransactionModel {
  final String id;
  final String userId;
  final TransactionCategory category;
  final TransactionType type;
  final String? title;
  final String? description;
  final double amount;
  final DateTime date;
  final String? attachmentUrl;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.type,
    this.title,
    this.description,
    required this.amount,
    required this.date,
    this.attachmentUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'category': category.name,
      'type': type.name,
      'title': title,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'attachmentUrl': attachmentUrl,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      category: TransactionCategoryExtension.fromString(
        map['category'] ?? 'outros',
      ),
      type: TransactionTypeExtension.fromString(map['type'] ?? 'saque'),
      title: map['title'],
      description: map['description'],
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      attachmentUrl: map['attachmentUrl'],
    );
  }
}
