import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';
import 'package:tech_challenge_3/models/enums/transaction_categories.dart';
import 'package:tech_challenge_3/models/enums/transaction_type.dart';
import 'package:tech_challenge_3/models/transaction_model.dart';

class TransactionWidget extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final category = transaction.category;
    final amountColor =
        transaction.type.direction == TransactionDirection.expense
        ? AppColors.stateError
        : AppColors.stateSuccess;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: category.colors,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(category.icon, color: AppColors.text100, size: 26),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    transaction.description,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    transaction.formattedCreatedAt,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            Text(
              transaction.formattedAmount,
              style: TextStyle(fontWeight: FontWeight.bold, color: amountColor),
            ),
          ],
        ),
      ),
    );
  }
}
