import 'package:equatable/equatable.dart';

import '../../class_repository.dart';

class Exam extends Equatable {
  final String? id;
  final String? classId;
  final String? title;
  final List<Material>? materials;
  final List<String>? studentWorks;
  final double? score;
  final String? feedback;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? returnTime;

  const Exam({
    this.id,
    this.title,
    this.classId,
    this.materials,
    this.studentWorks,
    this.score,
    this.feedback,
    this.startTime,
    this.endTime,
    this.returnTime
  });

  @override
  List<Object?> get props => [id, classId, title, materials, studentWorks, score, feedback, startTime, endTime, returnTime];
}
