import 'package:flutter/material.dart';

typedef FiltersChipBuilder<T> = Widget Function(
  BuildContext context,
  T option,
  bool isSelected,
  ValueChanged<bool> onSelected,
);

class FiltersSection<T> extends StatelessWidget {
  final String title;
  final Iterable<T> options;
  final TextStyle? titleStyle;
  final double spacing;
  final double runSpacing;
  final FiltersChipBuilder<T> chipBuilder;
  final bool Function(T option) isSelected;
  final void Function(T option, bool isSelected) onOptionSelected;

  const FiltersSection({
    super.key,
    required this.title,
    required this.options,
    required this.chipBuilder,
    required this.isSelected,
    required this.onOptionSelected,
    this.titleStyle,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: options.map((option) {
            final selected = isSelected(option);
            return chipBuilder(
              context,
              option,
              selected,
              (value) => onOptionSelected(option, value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
