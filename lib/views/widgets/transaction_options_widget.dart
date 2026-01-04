import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';
import 'package:tech_challenge_3/models/transaction_model.dart';
import 'package:tech_challenge_3/core/providers/transactions_provider.dart';
import 'package:tech_challenge_3/views/pages/create_transaction_page.dart';

class TransactionOptionsWidget extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionOptionsWidget({super.key, required this.transaction});

  void _confirmDelete(BuildContext context, TransactionsProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Excluir transação'),
          content: Text(
            'Tem certeza que deseja excluir "${transaction.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                provider.deleteTransaction(transaction.id);
                Navigator.of(ctx).pop();
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _viewAttachment(BuildContext context) {
    if (transaction.attachmentBase64 == null && transaction.attachmentUrl == null) return;

    Widget imageWidget;

    if (transaction.attachmentBase64 != null && transaction.attachmentBase64!.isNotEmpty) {
      // Exibir imagem do base64
      final base64String = transaction.attachmentBase64!.contains(',')
          ? transaction.attachmentBase64!.split(',')[1]
          : transaction.attachmentBase64!;

      imageWidget = Image.memory(
        base64Decode(base64String),
        fit: BoxFit.contain,
      );
    } else if (transaction.attachmentUrl != null && transaction.attachmentUrl!.isNotEmpty) {
      // Exibir imagem da URL (compatibilidade com anexos antigos)
      imageWidget = Image.network(
        transaction.attachmentUrl!,
        fit: BoxFit.contain,
      );
    } else {
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            imageWidget,
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Fechar"),
            ),
          ],
        ),
      ),
    );
  }

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
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Editar'),
              onTap: () {
                Navigator.pop(context);
                CreateTransactionPage.show(context, transaction: transaction);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Excluir', style: TextStyle(color: Colors.red)),
              onTap: () {
                final provider = context.read<TransactionsProvider?>();
                if (provider == null) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erro: Provider não disponível'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                Navigator.pop(context);
                _confirmDelete(context, provider);
              },
            ),

            if ((transaction.attachmentBase64 != null && transaction.attachmentBase64!.isNotEmpty) ||
                (transaction.attachmentUrl != null && transaction.attachmentUrl!.isNotEmpty))
              ListTile(
                leading: const Icon(Icons.attach_file_outlined),
                title: const Text('Visualizar anexo'),
                onTap: () {
                  Navigator.pop(context);
                  _viewAttachment(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
