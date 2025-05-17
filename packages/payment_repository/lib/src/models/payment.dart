class Payment {
  final String id;
  final int amount;
  final String method;
  final String note;
  final List<String> billImages;
  final DateTime createdAt;
  final List<String> lessonIds;

  Payment({
    required this.id,
    required this.amount,
    required this.method,
    required this.note,
    required this.billImages,
    required this.createdAt,
    required this.lessonIds,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      amount: json['amount'] as int,
      method: json['method'] as String,
      note: json['note'] as String,
      billImages: List<String>.from(json['billImages'] as List),
      createdAt: DateTime.parse(json['createAt'] as String),
      lessonIds: List<String>.from(json['lessonIds'] as List),
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
    };
  }
}