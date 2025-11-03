import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';
import 'package:tech_challenge_3/models/transaction_model.dart';

class TransactionOptionsWidget extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionOptionsWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ).copyWith(top: 12, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              transaction.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Editar'),
              onTap: () {
                Navigator.pop(context);
                // Chame sua função de edição aqui
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Excluir'),
              onTap: () {
                Navigator.pop(context);
                // Confirmação antes de excluir
                // _confirmDelete(context, transaction);
              },
            ),
          ],
        ),
      ),
    );
  }
}
