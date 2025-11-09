part of './withdrawals_by_category_chart.dart';

class _CategoryLegendItem extends StatelessWidget {
  const _CategoryLegendItem({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  final TransactionCategory category;
  final double amount;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: category.colors,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.label, style: Theme.of(context).textTheme.labelLarge),
            Text(
              '${FormatterUtils.formatAmount(amount)} · ${percentage.toStringAsFixed(1)}%',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.text200),
            ),
          ],
        ),
      ],
    );
  }
}
