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
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtros avançados',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Direção'),
                    const SizedBox(height: 8),
                    _buildDirectionChips(),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Tipos de transação'),
                    const SizedBox(height: 8),
                    _buildTypeChips(),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Categorias'),
                    const SizedBox(height: 8),
                    _buildCategoryChips(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: AppColors.text200,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDirectionChips() {
    return Wrap(
      spacing: 8,
      children: TransactionDirection.values.map((direction) {
        final isSelected = _selectedDirection == direction;
        final label = direction == TransactionDirection.income
            ? 'Entradas'
            : 'Saídas';
        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              _selectedDirection = isSelected ? null : direction;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildTypeChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TransactionType.values.map((type) {
        final isSelected = _selectedTypes.contains(type);
        return FilterChip(
          label: Text(type.label),
          selected: isSelected,
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
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TransactionCategory.values.map((category) {
        final isSelected = _selectedCategories.contains(category);
        return FilterChip(
          avatar: Icon(
            category.icon,
            size: 16,
            color: isSelected ? AppColors.text100 : AppColors.text200,
          ),
          label: Text(category.label),
          selected: isSelected,
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
