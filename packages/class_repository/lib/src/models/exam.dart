import 'package:equatable/equatable.dart';

class Exam extends Equatable {
  final List<String>? materials;
  final List<String>? studentWorks;
  final double? score;
  final String? feedback;
  final String? startTime;
  final String? endTime;
  final String? returnTime;

  const Exam({
    this.materials,
    this.studentWorks,
    this.score,
    this.feedback,
    this.startTime,
    this.endTime,
    this.returnTime
  });

  @override
  List<Object?> get props => [materials, studentWorks, score, feedback, startTime, endTime, returnTime];
}
