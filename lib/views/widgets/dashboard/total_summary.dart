import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_challenge_3/core/providers/transactions_provider.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';
import 'package:tech_challenge_3/core/utils/formatter_utils.dart';

class TotalSummary extends StatelessWidget {
  const TotalSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final totalIncome = context.select<TransactionsProvider?, double>(
      (provider) => provider?.totalIncome ?? 0.0,
    );
    final totalOutcome = context.select<TransactionsProvider?, double>(
      (provider) => provider?.totalOutcome ?? 0.0,
    );

    final totalBalance = context.select<TransactionsProvider?, double>(
      (provider) => provider?.balance ?? 0.0,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.text200,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      FormatterUtils.formatAmount(totalBalance),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: AppColors.text300),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: AppColors.border200),
            const SizedBox(height: 12),
            Row(
              children: [
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.stateSuccess,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: AppColors.background100,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entradas',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.text200,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      FormatterUtils.formatAmount(totalIncome),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: AppColors.stateSuccess),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: AppColors.border200),
            const SizedBox(height: 12),
            Row(
              children: [
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.stateError,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(
                      Icons.arrow_downward,
                      color: AppColors.background100,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saídas',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.text200,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      FormatterUtils.formatAmount(totalOutcome),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: AppColors.stateError),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
