import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';

class TransactionMapper {
  const TransactionMapper._();

  static TransactionEntity fromMap(Map<String, dynamic> map) {
    final type = _parseType(map['type']);

    return TransactionEntity(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      category: _parseCategory(map['category']),
      type: type,
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      createdAt:
          _parseDate(map['createdAt']) ??
          _parseDate(map['date']) ??
          DateTime.now(),
      updatedAt: _parseDate(map['updatedAt']),
      attachmentUrl: map['attachmentUrl'] as String?,
      attachmentBase64: map['attachmentBase64'] as String?,
    );
  }

  static Map<String, dynamic> toMap(TransactionEntity entity) {
    return {
      'id': entity.id,
      'userId': entity.userId,
      'category': entity.category.name,
      'type': entity.type.name,
      'title': entity.title,
      'description': entity.description,
      'amount': entity.amount,
      'createdAt': entity.createdAt.toIso8601String(),
      'updatedAt': entity.updatedAt?.toIso8601String(),
      'attachmentUrl': entity.attachmentUrl,
      'attachmentBase64': entity.attachmentBase64,
    };
  }

  static TransactionType _parseType(dynamic value) {
    final raw = value?.toString();
    return TransactionType.values.firstWhere(
      (item) => item.name == raw,
      orElse: () => TransactionType.payment,
    );
  }

  static TransactionCategory _parseCategory(dynamic value) {
    final raw = value?.toString();
    return TransactionCategory.values.firstWhere(
      (item) => item.name == raw,
      orElse: () => TransactionCategory.other,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
