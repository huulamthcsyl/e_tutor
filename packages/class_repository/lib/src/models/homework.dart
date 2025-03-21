import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';

class Homework extends Equatable {
  final String? id;
  final String title;
  final List<Material>? materials;
  final List<Material>? studentWorks;
  final double? score;
  final String? feedback;
  final DateTime? createdAt;
  final DateTime? dueDate;
  final DateTime? submittedAt;
  final String? status;
  final String? classId;
  final String? lessonId;

  const Homework({
    this.id,
    required this.title,
    this.materials,
    this.studentWorks,
    this.score,
    this.feedback,
    this.createdAt,
    this.dueDate,
    this.status,
    this.submittedAt,
    this.classId,
    this.lessonId
  });

  @override
  List<Object?> get props => [title, materials, studentWorks, score, feedback, createdAt, dueDate, status, submittedAt, classId, lessonId];
}
