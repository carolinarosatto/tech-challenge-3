import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';
import 'package:tech_challenge_3/core/utils/formatter_utils.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';
import 'package:tech_challenge_3/features/transactions/presentation/extensions/transaction_presentation_extensions.dart';
import 'package:tech_challenge_3/views/widgets/transaction_options_widget.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({super.key, required this.transaction});

  final TransactionEntity transaction;

  void _showTransactionOptions(
    BuildContext context,
    TransactionEntity transaction,
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
    final hasAttachment =
        (transaction.attachmentBase64?.isNotEmpty ?? false) ||
        (transaction.attachmentUrl?.isNotEmpty ?? false);

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
                  color: category.color,
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
                    Row(
                      children: [
                        Text(
                          transaction.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (hasAttachment)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(Icons.attach_file_outlined, size: 18),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.text200),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      FormatterUtils.formatDate(transaction.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                FormatterUtils.formatAmount(transaction.amount),
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
