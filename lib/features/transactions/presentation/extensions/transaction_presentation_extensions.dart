import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';

extension TransactionTypePresentation on TransactionType {
  String get label {
    switch (this) {
      case TransactionType.deposit:
        return 'Depósito';
      case TransactionType.withdrawal:
        return 'Saque';
      case TransactionType.investment:
        return 'Investimento';
      case TransactionType.income:
        return 'Rendimento';
      case TransactionType.payment:
        return 'Pagamento';
      case TransactionType.transfer:
        return 'Transferência';
    }
  }
}

extension TransactionDirectionPresentation on TransactionDirection {
  String get label {
    switch (this) {
      case TransactionDirection.income:
        return 'Entradas';
      case TransactionDirection.expense:
        return 'Saídas';
    }
  }
}

extension TransactionCategoryPresentation on TransactionCategory {
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
      case TransactionCategory.deposit:
        return 'Depósito';
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
      case TransactionCategory.deposit:
        return Icons.attach_money_sharp;
      case TransactionCategory.other:
        return Icons.receipt_outlined;
    }
  }

  Color get color {
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
      case TransactionCategory.deposit:
        return AppColors.stateSuccess;
      case TransactionCategory.other:
        return AppColors.categoryOther;
    }
  }
}
