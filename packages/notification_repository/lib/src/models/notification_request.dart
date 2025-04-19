class NotificationRequest {
  final String title;
  final String body;
  final String userId;
  final String documentId;
  final String documentType;

  const NotificationRequest({
    required this.title,
    required this.body,
    required this.userId,
    required this.documentId,
    required this.documentType,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'userId': userId,
      'documentId': documentId,
      'documentType': documentType,
    };
  }
}