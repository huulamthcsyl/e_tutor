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

  const Homework({
    this.id,
    required this.title,
    this.materials,
    this.studentWorks,
    this.score,
    this.feedback,
    this.createdAt,
    this.dueDate,
    this.submittedAt,
  });

  @override
  List<Object?> get props => [title, materials, studentWorks, score, feedback, createdAt, dueDate, submittedAt];
}
