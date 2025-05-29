part of 'create_lesson_cubit.dart';

class CreateLessonState extends Equatable {

  final String classId;
  final FormzSubmissionStatus status;
  final DateTime startTime;
  final DateTime endTime;

  const CreateLessonState({
    this.classId = '',
    this.status = FormzSubmissionStatus.initial,
    this.startTime = const ConstDateTime(0),
    this.endTime = const ConstDateTime(0)
  });

  @override
  List<Object> get props => [classId, status, startTime, endTime];

  CreateLessonState copyWith({
    String? classId,
    FormzSubmissionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return CreateLessonState(
      classId: classId ?? this.classId,
      status: status ?? this.status,
      startTime: startDate ?? this.startTime,
      endTime: endDate ?? this.endTime
    );
  }
}
