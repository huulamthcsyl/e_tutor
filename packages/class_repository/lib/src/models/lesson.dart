import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  final String? id;
  final String classId;
  final List<Material> materials;
  final List<String> homeworks;
  final bool? isPaid;
  final String? tutorFeedback;
  final String? studentFeedback;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? createdAt;

  const Lesson({
    this.id,
    required this.classId,
    required this.materials,
    required this.homeworks,
    this.isPaid,
    this.tutorFeedback,
    this.studentFeedback,
    this.startTime,
    this.endTime,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, classId, materials, homeworks, isPaid, tutorFeedback, studentFeedback, startTime, endTime, createdAt];
}
