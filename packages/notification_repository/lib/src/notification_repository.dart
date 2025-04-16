import 'package:cloud_firestore/cloud_firestore.dart';

import '../notification_repository.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore;

  NotificationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> sendFCMDeviceToken(String userId, String token) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'fcm_token': token,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to send FCM device token: $e');
    }
  }

  Stream<int> getNotificationCount(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<List<NotificationDoc>> getNotifications(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return NotificationDoc(
          id: doc.id,
          title: data['title'],
          body: data['body'],
          documentId: doc['documentId'],
          documentType: doc['documentType'],
          isRead: doc['isRead'],
          createdAt: DateTime.parse(data['createdAt']),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }
}