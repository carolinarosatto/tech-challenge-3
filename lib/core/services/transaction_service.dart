import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:tech_challenge_3/models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final String userId;

  TransactionService({required this.userId});

  CollectionReference get _transactionsRef =>
      _firestore.collection('users').doc(userId).collection('transactions');

  Stream<List<TransactionModel>> getTransactions() {
    return _transactionsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        data['id'] = doc.id;
        return TransactionModel.fromMap(data);
      }).toList();
    });
  }

  Future<void> saveTransaction({
    required TransactionModel transaction,
    Uint8List? imageBytes,
  }) async {
    try {
      String? base64Image;

      if (imageBytes != null) {
        base64Image = await _compressAndConvertToBase64(imageBytes);
      }

      final transactionToSave = TransactionModel(
        id: transaction.id.isEmpty ? _transactionsRef.doc().id : transaction.id,
        userId: userId,
        category: transaction.category,
        type: transaction.type,
        title: transaction.title,
        description: transaction.description,
        amount: transaction.amount,
        createdAt: transaction.createdAt,
        updatedAt: DateTime.now(),
        attachmentUrl: transaction.attachmentUrl,
        attachmentBase64: base64Image ?? transaction.attachmentBase64,
      );

      await _transactionsRef
          .doc(transactionToSave.id)
          .set(transactionToSave.toMap(), SetOptions(merge: true));

    } catch (e) {
      rethrow;
    }
  }

  Future<String> _compressAndConvertToBase64(Uint8List bytes) async {
    final compressedBytes = await FlutterImageCompress.compressWithList(
      bytes,
      quality: 50,
      minWidth: 800,
      minHeight: 600,
    );

    if (compressedBytes.isEmpty) {
      throw Exception('Falha ao comprimir imagem');
    }

    final base64String = base64Encode(compressedBytes);
    return 'data:image/jpeg;base64,$base64String';
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _transactionsRef.doc(transactionId).delete();

  }
}
