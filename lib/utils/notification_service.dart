import 'package:class_repository/class_repository.dart';
import 'package:notification_repository/notification_repository.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final NotificationRepository _notificationRepository = NotificationRepository();
  final ClassRepository _classRepository = ClassRepository();

  Future<void> sendNotification(String userId, String title, String body, String documentId, String documentType) async {
    try {
      final request = NotificationRequest(
        userId: userId,
        title: title,
        body: body,
        documentId: documentId,
        documentType: documentType,
      );
      await _notificationRepository.sendNotification(request);
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }

  Future<void> sendNotifications({
    required List<String> userIds,
    required String title,
    required String body,
    required String documentId,
    required String documentType,
  }) async {
    try {
      for (String userId in userIds) {
        await sendNotification(userId, title, body, documentId, documentType);
      }
    } catch (e) {
      throw Exception('Failed to send notifications: $e');
    }
  }

  Future<void> sendNotificationToClass({
    required String classId,
    required String title,
    required String body,
    required String documentId,
    required String documentType,
  }) async {
    try {
      final classData = await _classRepository.getClass(classId);
      await sendNotifications(
        userIds: classData.members!,
        title: title,
        body: body,
        documentId: documentId,
        documentType: documentType,
      );
    } catch (e) {
      throw Exception('Failed to send notification to class: $e');
    }
  }
}