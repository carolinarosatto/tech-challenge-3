import 'package:tech_challenge_3/core/utils/formatter_utils.dart';

import 'enums/transaction_categories.dart';
import 'enums/transaction_type.dart';

class TransactionModel {
  final String id;
  final String userId;
  final TransactionCategory category;
  final TransactionType type;
  final String title;
  final String description;
  final double amount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? attachmentUrl;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.type,
    String? title,
    String? description,
    required this.amount,
    required this.createdAt,
    this.updatedAt,
    this.attachmentUrl,
  }) : title = (title != null && title.isNotEmpty) ? title : type.label,
       description = description ?? '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'category': category.name,
      'type': type.name,
      'title': title,
      'description': description,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'attachmentUrl': attachmentUrl,
    };
  }

  String get formattedAmount => FormatterUtils.formatAmount(amount);
  String get formattedCreatedAt => FormatterUtils.formatDate(createdAt);
  String get formattedUpdatedAt => FormatterUtils.formatDate(updatedAt!);

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    final type = TransactionTypeExtension.fromString(
      map['type'] ?? TransactionType.payment,
    );

    return TransactionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      category: TransactionCategoryExtension.fromString(
        map['category'] ?? 'outros',
      ),
      type: type,
      title: map['title'],
      description: map['description'],
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? ''),
      attachmentUrl: map['attachmentUrl'],
    );
  }
}
