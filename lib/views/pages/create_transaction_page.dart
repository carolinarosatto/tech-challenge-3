import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tech_challenge_3/core/providers/auth_provider.dart';
import 'package:tech_challenge_3/core/providers/transactions_provider.dart';
import 'package:tech_challenge_3/core/services/transaction_service.dart';

import 'package:tech_challenge_3/core/theme/colors.dart';
import 'package:tech_challenge_3/models/enums/transaction_categories.dart';
import 'package:tech_challenge_3/models/enums/transaction_type.dart';
import 'package:tech_challenge_3/models/transaction_model.dart';

class CreateTransactionPage extends StatefulWidget {
  final TransactionModel? transaction;

  const CreateTransactionPage({super.key, this.transaction});

  static Future<void> show(
    BuildContext context, {
    TransactionModel? transaction,
  }) async {
    await Navigator.of(context).push(
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

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  late TransactionType _selectedType;
  late TransactionCategory _selectedCategory;
  late DateTime _selectedDate;

  String? _currentAttachmentUrl;
  File? _pickedFile;
  final ImagePicker _picker = ImagePicker();

  bool get _isEditing => widget.transaction != null;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final t = widget.transaction!;
      _titleController.text = t.title;
      _descriptionController.text = t.description;
      _amountController.text = t.amount.toString();
      _selectedType = t.type;
      _selectedCategory = t.category;
      _selectedDate = t.createdAt;
      _currentAttachmentUrl = t.attachmentUrl;
    } else {
      _selectedType = TransactionType.payment;
      _selectedCategory = TransactionCategory.other;
      _selectedDate = DateTime.now();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );
    if (picked != null) {
      setState(() {
        _pickedFile = File(picked.path);
      });
    }
  }

  void _clearAttachment() {
    setState(() {
      _pickedFile = null;
      _currentAttachmentUrl = null;
    });
  }

  void _showImageSourceModal() {
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
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAttachmentPreview() {
    if (_pickedFile != null) {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(_pickedFile!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          IconButton(
            onPressed: _clearAttachment,
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.close, color: Colors.red),
            ),
          ),
        ],
      );
    }

    if (_currentAttachmentUrl != null && _currentAttachmentUrl!.isNotEmpty) {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              image: DecorationImage(
                image: NetworkImage(_currentAttachmentUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          IconButton(
            onPressed: _clearAttachment,
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.close, color: Colors.red),
            ),
          ),
        ],
      );
    }

    return InkWell(
      onTap: _showImageSourceModal,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade400,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_enhance, size: 40, color: Colors.grey.shade600),
            const SizedBox(height: 8),
            Text(
              "Adicionar comprovante/foto",
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final authProvider = context.read<AuthProvider>();
    final transactionsProvider = context.read<TransactionsProvider?>();
    final userId = authProvider.user?.uid;

    if (userId == null) {
      _showError('Erro: Usuário não autenticado');
      return;
    }

    if (transactionsProvider == null) {
      _showError('Erro: Provider de transações não disponível');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final double amount =
          double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;

      final service = TransactionService(userId: userId);

      final transactionModel = TransactionModel(
        id: _isEditing ? widget.transaction!.id : '',
        userId: userId,
        category: _selectedCategory,
        type: _selectedType,
        title: _titleController.text,
        description: _descriptionController.text,
        amount: amount,
        createdAt: _selectedDate,
        updatedAt: _isEditing ? DateTime.now() : null,

        attachmentUrl: _pickedFile == null ? _currentAttachmentUrl : null,
      );

      await service.saveTransaction(
        transaction: transactionModel,
        imageFile: _pickedFile,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transação salva com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? "Editar Transação" : "Nova Transação",
          style: TextStyle(color: AppColors.text100),
        ),
        backgroundColor: AppColors.brand500,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Informe um título'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Valor (R\$) *',
                      prefixText: 'R\$ ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Informe um valor';
                      }
                      final value = double.tryParse(val.replaceAll(',', '.'));
                      if (value == null) {
                        return 'Valor inválido';
                      }
                      if (value < 0) {
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
                          initialValue: _selectedType,
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
                          onChanged: (val) => setState(() {
                            if(val == TransactionType.deposit) {
                              _selectedCategory = TransactionCategory.deposit;
                            } else {
                              _selectedCategory = TransactionCategory.other;
                            }
                            _selectedType = val!;
                          }),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Data',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(_selectedDate),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_selectedType != TransactionType.deposit) ...[
                    DropdownButtonFormField<TransactionCategory>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Categoria',
                        border: OutlineInputBorder(),
                      ),
                      items: TransactionCategory.values
                          .map(
                            (cat) => DropdownMenuItem(
                              value: cat,
                              child: Row(
                                children: [
                                  Icon(cat.icon, color: cat.colors, size: 20),
                                  const SizedBox(width: 8),
                                  Text(cat.label),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedCategory = val!),
                    ),
                    const SizedBox(height: 16),
                  ],  
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    "Anexo / Comprovante",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildAttachmentPreview(),

                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand500,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            _isEditing ? 'Atualizar' : 'Criar',
                            style: TextStyle(color: AppColors.text100),
                          ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
