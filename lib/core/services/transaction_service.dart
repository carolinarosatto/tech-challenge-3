import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    File? imageFile,
  }) async {
    try {
      String? downloadUrl = transaction.attachmentUrl;

      if (imageFile != null) {
        downloadUrl = await _uploadImage(imageFile, transaction.id);
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
        attachmentUrl: downloadUrl,
      );

      await _transactionsRef
          .doc(transactionToSave.id)
          .set(transactionToSave.toMap(), SetOptions(merge: true));
          
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _uploadImage(File file, String transactionId) async {
  
    final String fileName = '${transactionId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference ref = _storage.ref().child('uploads/$userId/$fileName');

    final UploadTask uploadTask = ref.putFile(file);
    final TaskSnapshot snapshot = await uploadTask;
    
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _transactionsRef.doc(transactionId).delete();
  
  }
}