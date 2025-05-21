class Payment {
  final String id;
  final int amount;
  final String method;
  final String note;
  final List<String> billImages;
  final DateTime createdAt;
  final List<String> lessonIds;
  final String parentId;
  final String tutorId;

  const Payment({
    required this.id,
    required this.amount,
    required this.method,
    required this.note,
    required this.billImages,
    required this.createdAt,
    required this.lessonIds,
    required this.parentId,
    required this.tutorId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      amount: json['amount'] as int,
      method: json['method'] as String,
      note: json['note'] as String,
      billImages: List<String>.from(json['billImages'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lessonIds: List<String>.from(json['lessonIds'] as List),
      parentId: json['parentId'] as String,
      tutorId: json['tutorId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'method': method,
      'note': note,
      'billImages': billImages,
      'createdAt': createdAt.toIso8601String(),
      'lessonIds': lessonIds,
      'parentId': parentId,
      'tutorId': tutorId,
    };
  }
}