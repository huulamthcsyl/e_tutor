import 'package:equatable/equatable.dart';

class NotificationDoc extends Equatable {
  final String id;
  final String title;
  final String body;
  final String documentId;
  final String documentType;
  final bool isRead;
  final DateTime createdAt;

  const NotificationDoc({
    required this.id,
    required this.title,
    required this.body,
    required this.documentId,
    required this.documentType,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, title, body, documentId, documentType, isRead, createdAt];
}