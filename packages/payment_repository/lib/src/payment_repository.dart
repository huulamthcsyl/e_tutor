import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:payment_repository/src/models/models.dart';
import 'dart:typed_data';

class PaymentRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  PaymentRepository({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Future<void> createPayment(Payment payment) async {
    try {
      await _firestore.collection('payments').doc(payment.id).set(payment.toJson());
      for (var lessonId in payment.lessonIds) {
        await _firestore.collection('lessons').doc(lessonId).update({
          'isPaid': true,
        });
      }
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }

  Future<String> uploadBillImage(String paymentId, String fileName, Uint8List file) async {
    try {
      final ref = _storage.ref().child('payments/$paymentId/$fileName');
      await ref.putData(file);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload bill image: $e');
    }
  }
}