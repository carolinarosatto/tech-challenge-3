enum TransactionType {
  deposit,
  withdrawal,
  investment,
  income,
  payment,
  transfer,
}

enum TransactionDirection { income, expense }

enum TransactionCategory {
  food,
  transport,
  habitation,
  leisure,
  health,
  education,
  pets,
  deposit,
  other,
}

extension TransactionTypeRules on TransactionType {
  TransactionDirection get direction {
    switch (this) {
      case TransactionType.deposit:
      case TransactionType.income:
        return TransactionDirection.income;
      case TransactionType.withdrawal:
      case TransactionType.investment:
      case TransactionType.payment:
      case TransactionType.transfer:
        return TransactionDirection.expense;
    }
  }
}

class TransactionEntity {
  TransactionEntity({
    required this.id,
    required this.userId,
    required this.category,
    required this.type,
    required String title,
    String? description,
    required this.amount,
    required this.createdAt,
    this.updatedAt,
    this.attachmentUrl,
    this.attachmentBase64,
  }) : title = title.isNotEmpty ? title : type.name,
       description = description ?? '';

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
  final String? attachmentBase64;

  TransactionEntity copyWith({
    String? id,
    String? userId,
    TransactionCategory? category,
    TransactionType? type,
    String? title,
    String? description,
    double? amount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? attachmentUrl,
    String? attachmentBase64,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      attachmentBase64: attachmentBase64 ?? this.attachmentBase64,
    );
  }
}
