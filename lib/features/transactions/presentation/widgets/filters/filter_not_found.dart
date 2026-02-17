import 'package:flutter/material.dart';

class FilterNotFound extends StatelessWidget {
  final VoidCallback? onClear;
  const FilterNotFound({required this.onClear, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.filter_alt_off_outlined,
            color: Colors.grey,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma transação encontrada com os filtros selecionados.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onClear, child: const Text('Limpar filtros')),
        ],
      ),
    );
  }
}
