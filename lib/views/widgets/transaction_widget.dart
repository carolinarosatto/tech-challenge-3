import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';
import 'package:tech_challenge_3/models/enums/transaction_categories.dart';
import 'package:tech_challenge_3/models/enums/transaction_type.dart';
import 'package:tech_challenge_3/models/transaction_model.dart';
import 'package:tech_challenge_3/views/widgets/transaction_options_widget.dart';

class TransactionWidget extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionWidget({super.key, required this.transaction});

  void _showTransactionOptions(
    BuildContext context,
    TransactionModel transaction,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => TransactionOptionsWidget(transaction: transaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = transaction.category;
    final amountColor =
        transaction.type.direction == TransactionDirection.expense
        ? AppColors.stateError
        : AppColors.stateSuccess;

    return InkWell(
      onTap: () => _showTransactionOptions(context, transaction),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: category.colors,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(category.icon, color: AppColors.text100, size: 28),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    SizedBox(height: 4),
                    Text(
                      transaction.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.text200),
                    ),
                    SizedBox(height: 4),
                    Text(
                      transaction.formattedCreatedAt,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Text(
                transaction.formattedAmount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
