part of 'class_lesson_cubit.dart';

enum ClassLessonStateStatus { initial, loading, success, failure }

class ClassLessonState extends Equatable {

  final String classId;
  final List<Lesson> lessons;
  final ClassLessonStateStatus status;
  final DateTime startTime;
  final DateTime endTime;

  final now = DateTime.now();

  ClassLessonState({
    this.classId = '',
    this.lessons = const [],
    this.status = ClassLessonStateStatus.initial,
    this.startTime = const ConstDateTime(0),
    this.endTime = const ConstDateTime(0),
  });

  @override
  List<Object> get props => [classId, lessons, status, startTime, endTime];

  ClassLessonState copyWith({
    String? classId,
    List<Lesson>? lessons,
    ClassLessonStateStatus? status,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return ClassLessonState(
      classId: classId ?? this.classId,
      lessons: lessons ?? this.lessons,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
