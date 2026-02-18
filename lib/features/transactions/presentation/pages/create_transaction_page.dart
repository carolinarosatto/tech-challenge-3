import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';
import 'package:tech_challenge_3/features/transactions/presentation/pages/create_transaction_form_controller.dart';
import 'package:tech_challenge_3/features/transactions/presentation/pages/create_transaction_page_actions.dart';
import 'package:tech_challenge_3/features/transactions/presentation/widgets/forms/attachment_preview.dart';
import 'package:tech_challenge_3/features/transactions/presentation/widgets/forms/transaction_form_fields.dart';

class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({super.key, this.transaction});

  final TransactionEntity? transaction;

  static Future<void> show(
    BuildContext context, {
    TransactionEntity? transaction,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateTransactionPage(transaction: transaction),
      ),
    );
  }

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  late final CreateTransactionFormController _form;

  @override
  void initState() {
    super.initState();
    _form = CreateTransactionFormController(
      initialTransaction: widget.transaction,
    )..initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _form.isEditing ? 'Editar Transação' : 'Nova Transação',
          style: const TextStyle(color: AppColors.text100),
        ),
        backgroundColor: AppColors.brand500,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TransactionFormFields(
                    titleController: _form.titleController,
                    amountController: _form.amountController,
                    descriptionController: _form.descriptionController,
                    selectedType: _form.selectedType,
                    selectedCategory: _form.selectedCategory,
                    selectedDate: _form.selectedDate,
                    onTypeChanged: (value) {
                      setState(() {
                        _form.updateType(value);
                      });
                    },
                    onCategoryChanged: (value) {
                      setState(() {
                        _form.updateCategory(value);
                      });
                    },
                    onPickDate: _pickDate,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Anexo / Comprovante',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  AttachmentPreview(
                    pickedImageBytes: _form.pickedImageBytes,
                    currentAttachmentBase64: _form.currentAttachmentBase64,
                    currentAttachmentUrl: _form.currentAttachmentUrl,
                    onSelectSource: _showImageSourceModal,
                    onClearAttachment: () {
                      setState(_form.clearAttachment);
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _form.isLoading ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand500,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _form.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            _form.isEditing ? 'Atualizar' : 'Criar',
                            style: const TextStyle(color: AppColors.text100),
                          ),
                  ),
                ],
              ),
            ),
          ),
          if (_form.isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    await CreateTransactionPageActions.pickImage(
      picker: _picker,
      source: source,
      form: _form,
      setState: setState,
      isMounted: () => mounted,
    );
  }

  void _showImageSourceModal() {
    CreateTransactionPageActions.showImageSourceModal(
      context: context,
      onPickImage: _pickImage,
    );
  }

  Future<void> _pickDate() async {
    await CreateTransactionPageActions.pickDate(
      context: context,
      initialDate: _form.selectedDate,
      setState: setState,
      onPicked: _form.updateDate,
    );
  }

  Future<void> _onSubmit() async {
    await CreateTransactionPageActions.submit(
      context: context,
      formKey: _formKey,
      form: _form,
      setState: setState,
      isMounted: () => mounted,
      showMessage: _showMessage,
    );
  }

  void _showMessage(String message, {required bool isError}) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }
}
