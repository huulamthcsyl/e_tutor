part of 'class_exam_cubit.dart';

enum ClassExamStatus { initial, loading, loaded, error }

class ClassExamState extends Equatable {

  final DateTime startTime;
  final DateTime endTime;
  final List<Exam> exams;
  final ClassExamStatus status;
  final String classId;

  const ClassExamState({
    this.startTime = const ConstDateTime(0),
    this.endTime = const ConstDateTime(0),
    this.exams = const [],
    this.status = ClassExamStatus.initial,
    this.classId = '',
  });

  @override
  List<Object?> get props => [startTime, endTime, exams, status, classId];

  ClassExamState copyWith({
    DateTime? startTime,
    DateTime? endTime,
    List<Exam>? exams,
    ClassExamStatus? status,
    String? classId,
  }) {
    return ClassExamState(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      exams: exams ?? this.exams,
      status: status ?? this.status,
      classId: classId ?? this.classId,
    );
  }
}
