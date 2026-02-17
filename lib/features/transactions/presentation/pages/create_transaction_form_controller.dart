import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';

class CreateTransactionFormController {
  CreateTransactionFormController({required this.initialTransaction});

  final TransactionEntity? initialTransaction;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();

  late TransactionType selectedType;
  late TransactionCategory selectedCategory;
  late DateTime selectedDate;

  String? currentAttachmentUrl;
  String? currentAttachmentBase64;
  Uint8List? pickedImageBytes;
  bool isLoading = false;

  bool get isEditing => initialTransaction != null;

  void initialize() {
    final transaction = initialTransaction;
    if (transaction == null) {
      selectedType = TransactionType.payment;
      selectedCategory = TransactionCategory.other;
      selectedDate = DateTime.now();
      return;
    }

    titleController.text = transaction.title;
    descriptionController.text = transaction.description;
    amountController.text = transaction.amount.toString();
    selectedType = transaction.type;
    selectedCategory = transaction.category;
    selectedDate = transaction.createdAt;
    currentAttachmentUrl = transaction.attachmentUrl;
    currentAttachmentBase64 = transaction.attachmentBase64;
  }

  void updateType(TransactionType value) {
    selectedType = value;
    if (value == TransactionType.deposit) {
      selectedCategory = TransactionCategory.deposit;
    } else if (selectedCategory == TransactionCategory.deposit) {
      selectedCategory = TransactionCategory.other;
    }
  }

  void updateCategory(TransactionCategory value) {
    selectedCategory = value;
  }

  void updateDate(DateTime value) {
    selectedDate = value;
  }

  void updatePickedImage(Uint8List? bytes) {
    pickedImageBytes = bytes;
  }

  void clearAttachment() {
    pickedImageBytes = null;
    currentAttachmentUrl = null;
    currentAttachmentBase64 = null;
  }

  TransactionEntity buildTransaction({required String userId}) {
    final amount =
        double.tryParse(amountController.text.replaceAll(',', '.')) ?? 0;

    return TransactionEntity(
      id: isEditing ? initialTransaction!.id : '',
      userId: userId,
      category: selectedCategory,
      type: selectedType,
      title: titleController.text,
      description: descriptionController.text,
      amount: amount,
      createdAt: selectedDate,
      updatedAt: isEditing ? DateTime.now() : null,
      attachmentUrl: pickedImageBytes == null ? currentAttachmentUrl : null,
      attachmentBase64: pickedImageBytes == null
          ? currentAttachmentBase64
          : null,
    );
  }

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    amountController.dispose();
  }
}
