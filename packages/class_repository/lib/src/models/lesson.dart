import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  final List<String>? materials;
  final List<Homework>? homeworks;
  final bool? isPaid;
  final String? tutorFeedback;
  final String? studentFeedback;
  final DateTime? startTime;
  final DateTime? endTime;

  const Lesson({
    this.materials,
    this.homeworks,
    this.isPaid,
    this.tutorFeedback,
    this.studentFeedback,
    this.startTime,
    this.endTime,
  });

  @override
  List<Object?> get props => [materials, homeworks, isPaid, tutorFeedback, studentFeedback, startTime, endTime];
}
