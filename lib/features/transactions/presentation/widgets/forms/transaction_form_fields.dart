import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';
import 'package:tech_challenge_3/features/transactions/presentation/extensions/transaction_presentation_extensions.dart';

class TransactionFormFields extends StatelessWidget {
  const TransactionFormFields({
    super.key,
    required this.titleController,
    required this.amountController,
    required this.descriptionController,
    required this.selectedType,
    required this.selectedCategory,
    required this.selectedDate,
    required this.onTypeChanged,
    required this.onCategoryChanged,
    required this.onPickDate,
  });

  final TextEditingController titleController;
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final TransactionType selectedType;
  final TransactionCategory selectedCategory;
  final DateTime selectedDate;
  final ValueChanged<TransactionType> onTypeChanged;
  final ValueChanged<TransactionCategory> onCategoryChanged;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Título *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Informe um título';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Valor (R\$) *',
            prefixText: 'R\$ ',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Informe um valor';
            }

            final parsed = double.tryParse(value.replaceAll(',', '.'));
            if (parsed == null) {
              return 'Valor inválido';
            }

            if (parsed < 0) {
              return 'O valor deve ser positivo';
            }

            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<TransactionType>(
                initialValue: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  border: OutlineInputBorder(),
                ),
                items: TransactionType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    onTypeChanged(value);
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: onPickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (selectedType != TransactionType.deposit) ...[
          DropdownButtonFormField<TransactionCategory>(
            initialValue: selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Categoria',
              border: OutlineInputBorder(),
            ),
            items: TransactionCategory.values
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Icon(category.icon, color: category.color, size: 20),
                        const SizedBox(width: 8),
                        Text(category.label),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                onCategoryChanged(value);
              }
            },
          ),
          const SizedBox(height: 16),
        ],
        TextFormField(
          controller: descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Descrição',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
