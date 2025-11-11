import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_challenge_3/core/providers/transactions_provider.dart';
import 'package:tech_challenge_3/models/enums/transaction_categories.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';
import 'package:tech_challenge_3/views/widgets/dashboard/outcome_by_category_chart.dart';
import 'package:tech_challenge_3/views/widgets/dashboard/total_summary.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final totalsEntries = context
        .select<
          TransactionsProvider,
          List<MapEntry<TransactionCategory, double>>
        >((provider) {
          final entries = provider.totalsByCategory.entries.toList();
          entries.sort((a, b) => b.value.compareTo(a.value));
          return entries;
        });
    final totalAmount = totalsEntries.fold<double>(
      0,
      (sum, entry) => sum + entry.value,
    );

    final hasData = totalAmount > 0 && totalsEntries.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TotalSummary(),
          const SizedBox(height: 16),
          Card(
            color: AppColors.background100,
            surfaceTintColor: AppColors.background100,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: OutcomeByCategoryChart(
                totalsEntries: totalsEntries,
                totalAmount: totalAmount,
                hasData: hasData,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
