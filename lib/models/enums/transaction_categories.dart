import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';

enum TransactionCategory {
  food,
  transport,
  habitation,
  leisure,
  health,
  education,
  pets,
  other,
}

extension TransactionCategoryExtension on TransactionCategory {
  String get label {
    switch (this) {
      case TransactionCategory.food:
        return 'Alimentação';
      case TransactionCategory.transport:
        return 'Transporte';
      case TransactionCategory.habitation:
        return 'Moradia';
      case TransactionCategory.leisure:
        return 'Lazer';
      case TransactionCategory.health:
        return 'Saúde';
      case TransactionCategory.education:
        return 'Educação';
      case TransactionCategory.pets:
        return 'Pets';
      case TransactionCategory.other:
        return 'Outros';
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionCategory.food:
        return Icons.restaurant_outlined;
      case TransactionCategory.transport:
        return Icons.directions_car_outlined;
      case TransactionCategory.habitation:
        return Icons.house_outlined;
      case TransactionCategory.leisure:
        return Icons.roller_skating_outlined;
      case TransactionCategory.health:
        return Icons.health_and_safety_outlined;
      case TransactionCategory.education:
        return Icons.school_outlined;
      case TransactionCategory.pets:
        return Icons.pets_outlined;
      case TransactionCategory.other:
        return Icons.receipt_outlined;
    }
  }

  Color get colors {
    switch (this) {
      case TransactionCategory.food:
        return AppColors.categoryFood;
      case TransactionCategory.transport:
        return AppColors.categoryTransport;
      case TransactionCategory.habitation:
        return AppColors.categoryHabitation;
      case TransactionCategory.leisure:
        return AppColors.categoryLeisure;
      case TransactionCategory.health:
        return AppColors.categoryHealth;
      case TransactionCategory.education:
        return AppColors.categoryEducation;
      case TransactionCategory.pets:
        return AppColors.categoryPets;
      case TransactionCategory.other:
        return AppColors.categoryOther;
    }
  }

  static TransactionCategory fromString(String value) {
    return TransactionCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TransactionCategory.other,
    );
  }
}
