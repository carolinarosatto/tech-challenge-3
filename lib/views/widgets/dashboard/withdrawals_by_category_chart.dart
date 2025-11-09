import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';
import 'package:tech_challenge_3/core/theme/typography.dart';
import 'package:tech_challenge_3/core/utils/formatter_utils.dart';
import 'package:tech_challenge_3/models/enums/transaction_categories.dart';
part 'package:tech_challenge_3/views/widgets/dashboard/dashboard_category_legend_item.dart';

class WithdrawalsByCategoryChart extends StatelessWidget {
  const WithdrawalsByCategoryChart({
    required this.totalsEntries,
    required this.totalAmount,
    required this.hasData,
    super.key,
  });

  final List<MapEntry<TransactionCategory, double>> totalsEntries;
  final double totalAmount;
  final bool hasData;

  @override
  Widget build(BuildContext context) {
    if (hasData == false) {
      return Center(
        child: Text(
          'Ainda não há dados suficientes para mostrar o gráfico.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gastos por categoria',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 56),
        SizedBox(
          height: 260,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 70,
                  pieTouchData: PieTouchData(enabled: false),
                  sections: totalsEntries.map((entry) {
                    return _buildSection(context, entry, totalAmount);
                  }).toList(),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.text200,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    FormatterUtils.formatAmount(totalAmount),
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.text200,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 56),
        Wrap(
          spacing: 24,
          runSpacing: 16,
          children: totalsEntries
              .map(
                (entry) => _CategoryLegendItem(
                  category: entry.key,
                  amount: entry.value,
                  percentage: entry.value / totalAmount * 100,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  PieChartSectionData _buildSection(
    BuildContext context,
    MapEntry<TransactionCategory, double> entry,
    double totalAmount,
  ) {
    final percentage = totalAmount == 0 ? 0 : (entry.value / totalAmount * 100);
    final showLabel = percentage >= 6;

    return PieChartSectionData(
      color: entry.key.colors,
      value: entry.value,
      title: showLabel ? entry.key.label : '',
      radius: 90,
      titleStyle: AppTypography.labelSmall.copyWith(color: AppColors.text100),
    );
  }
}
