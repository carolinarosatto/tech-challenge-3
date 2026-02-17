import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FirestoreTransactionsDatasource {
  FirestoreTransactionsDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _transactionsRef(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions');
  }

  String generateTransactionId({required String userId}) {
    return _transactionsRef(userId).doc().id;
  }

  Stream<List<Map<String, dynamic>>> watchTransactions({
    required String userId,
  }) {
    return _transactionsRef(
      userId,
    ).orderBy('createdAt', descending: true).snapshots().map(_mapSnapshot);
  }

  Stream<List<Map<String, dynamic>>> watchTransactionsPage({
    required String userId,
    required int limit,
  }) {
    return _transactionsRef(userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(_mapSnapshot);
  }

  Future<void> saveTransaction({
    required String userId,
    required String transactionId,
    required Map<String, dynamic> data,
  }) {
    return _transactionsRef(
      userId,
    ).doc(transactionId).set(data, SetOptions(merge: true));
  }

  Future<void> deleteTransaction({
    required String userId,
    required String transactionId,
  }) {
    return _transactionsRef(userId).doc(transactionId).delete();
  }

  Future<String> compressAndConvertToBase64(Uint8List bytes) async {
    final compressedBytes = await FlutterImageCompress.compressWithList(
      bytes,
      quality: 90,
      minWidth: 800,
      minHeight: 600,
    );

    if (compressedBytes.isEmpty) {
      throw Exception('Falha ao comprimir imagem');
    }

    final base64String = base64Encode(compressedBytes);
    return 'data:image/jpeg;base64,$base64String';
  }

  List<Map<String, dynamic>> _mapSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {...data, 'id': doc.id};
    }).toList();
  }
}
