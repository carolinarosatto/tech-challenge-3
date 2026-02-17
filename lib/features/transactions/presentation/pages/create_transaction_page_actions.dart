import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tech_challenge_3/features/transactions/presentation/providers/transactions_provider.dart';
import 'package:tech_challenge_3/features/transactions/presentation/pages/create_transaction_form_controller.dart';

typedef SetStateCallback = void Function(VoidCallback fn);
typedef IsMountedCallback = bool Function();
typedef ShowMessageCallback = void Function(
  String message, {
  required bool isError,
});

class CreateTransactionPageActions {
  const CreateTransactionPageActions._();

  static Future<void> pickImage({
    required ImagePicker picker,
    required ImageSource source,
    required CreateTransactionFormController form,
    required SetStateCallback setState,
    required IsMountedCallback isMounted,
  }) async {
    final picked = await picker.pickImage(source: source, imageQuality: 50);
    if (picked == null) {
      return;
    }

    final bytes = await picked.readAsBytes();
    if (!isMounted()) {
      return;
    }

    setState(() {
      form.updatePickedImage(bytes);
    });
  }

  static void showImageSourceModal({
    required BuildContext context,
    required Future<void> Function(ImageSource source) onPickImage,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Câmera'),
              onTap: () {
                Navigator.pop(context);
                onPickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () {
                Navigator.pop(context);
                onPickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> pickDate({
    required BuildContext context,
    required DateTime initialDate,
    required SetStateCallback setState,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      onPicked(picked);
    });
  }

  static Future<void> submit({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required CreateTransactionFormController form,
    required SetStateCallback setState,
    required IsMountedCallback isMounted,
    required ShowMessageCallback showMessage,
  }) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final transactionsProvider = context.read<TransactionsProvider?>();
    final navigator = Navigator.of(context);

    if (transactionsProvider == null) {
      showMessage('Erro: Provider de transações não disponível', isError: true);
      return;
    }

    final userId = transactionsProvider.userId;

    setState(() => form.isLoading = true);

    try {
      final success = await transactionsProvider.saveTransaction(
        transaction: form.buildTransaction(userId: userId),
        imageBytes: form.pickedImageBytes,
      );

      if (!isMounted()) {
        return;
      }

      if (success) {
        showMessage('Transação salva com sucesso!', isError: false);
        navigator.pop();
        return;
      }

      showMessage(
        transactionsProvider.errorMessage ?? 'Erro ao salvar transação',
        isError: true,
      );
    } catch (error) {
      showMessage('Erro ao salvar: $error', isError: true);
    } finally {
      if (isMounted()) {
        setState(() => form.isLoading = false);
      }
    }
  }
}
