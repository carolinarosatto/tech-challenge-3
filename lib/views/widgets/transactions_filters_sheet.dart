import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_challenge_3/core/providers/transactions_provider.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';
import 'package:tech_challenge_3/models/enums/transaction_categories.dart';
import 'package:tech_challenge_3/models/enums/transaction_type.dart';
import 'package:tech_challenge_3/models/transactions_filter.dart';

class TransactionsFiltersSheet extends StatefulWidget {
  const TransactionsFiltersSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      builder: (_) => const TransactionsFiltersSheet(),
    );
  }

  @override
  State<TransactionsFiltersSheet> createState() =>
      _TransactionsFiltersSheetState();
}

class _TransactionsFiltersSheetState extends State<TransactionsFiltersSheet> {
  late Set<TransactionType> _selectedTypes;
  late Set<TransactionCategory> _selectedCategories;
  TransactionDirection? _selectedDirection;

  @override
  void initState() {
    super.initState();
    final provider = context.read<TransactionsProvider>();
    final filters = provider.filters;
    _selectedTypes = {...filters.types};
    _selectedCategories = {...filters.categories};
    _selectedDirection = filters.direction;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final sectionTitleStyle = textTheme.titleSmall?.copyWith(
      color: AppColors.text200,
      fontWeight: FontWeight.w600,
    );
    final chipTextStyle = textTheme.bodyMedium?.copyWith(
      color: AppColors.text300,
    );
    final chipSelectedTextStyle = textTheme.bodyMedium?.copyWith(
      color: AppColors.text100,
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filtros avançados', style: theme.textTheme.titleMedium),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(0),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Direção', style: sectionTitleStyle),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: TransactionDirection.values.map((direction) {
                          final isSelected = _selectedDirection == direction;
                          final label = direction == TransactionDirection.income
                              ? 'Entradas'
                              : 'Saídas';
                          return ChoiceChip(
                            selectedColor: AppColors.brand400,
                            label: Text(
                              label,
                              style: isSelected
                                  ? chipSelectedTextStyle
                                  : chipTextStyle,
                            ),
                            selected: isSelected,
                            showCheckmark: false,
                            onSelected: (_) {
                              setState(() {
                                _selectedDirection = isSelected
                                    ? null
                                    : direction;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text('Tipos de transação', style: sectionTitleStyle),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: TransactionType.values.map((type) {
                          final isSelected = _selectedTypes.contains(type);
                          return FilterChip(
                            selectedColor: AppColors.brand400,
                            label: Text(
                              type.label,
                              style: isSelected
                                  ? chipSelectedTextStyle
                                  : chipTextStyle,
                            ),
                            selected: isSelected,
                            showCheckmark: false,
                            onSelected: (_) {
                              setState(() {
                                if (isSelected) {
                                  _selectedTypes.remove(type);
                                } else {
                                  _selectedTypes.add(type);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text('Categorias', style: sectionTitleStyle),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: TransactionCategory.values.map((category) {
                          final isSelected = _selectedCategories.contains(
                            category,
                          );
                          final Color selectedColor =
                              category == TransactionCategory.other
                              ? AppColors.border400
                              : category.colors;

                          return FilterChip(
                            avatar: Icon(
                              category.icon,
                              size: 16,
                              color: isSelected
                                  ? AppColors.text100
                                  : AppColors.text300,
                            ),
                            label: Text(
                              category.label,
                              style: isSelected
                                  ? chipSelectedTextStyle
                                  : chipTextStyle,
                            ),
                            selected: isSelected,
                            selectedColor: selectedColor,
                            showCheckmark: false,
                            onSelected: (_) {
                              setState(() {
                                if (isSelected) {
                                  _selectedCategories.remove(category);
                                } else {
                                  _selectedCategories.add(category);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: _onApplyFilters,
                    child: const Text('Aplicar filtros'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _onClearFilters,
                    child: const Text('Limpar filtros'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onClearFilters() {
    context.read<TransactionsProvider>().clearFilters();
    Navigator.of(context).pop();
  }

  void _onApplyFilters() {
    final filters = TransactionsFilter(
      direction: _selectedDirection,
      types: Set<TransactionType>.from(_selectedTypes),
      categories: Set<TransactionCategory>.from(_selectedCategories),
    );

    context.read<TransactionsProvider>().updateFilters(filters);
    Navigator.of(context).pop();
  }
}
