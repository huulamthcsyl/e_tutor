part of 'lesson_cubit.dart';

enum LessonStatus { initial, loading, success, failure }

class LessonState extends Equatable {

  final LessonResponse lessonData;
  final Class classData;
  final LessonStatus status;

  const LessonState({
    this.lessonData = const LessonResponse(),
    this.classData = const Class(),
    this.status = LessonStatus.initial,
  });

  @override
  List<Object> get props => [lessonData, classData, status];

  LessonState copyWith({
    LessonResponse? lessonData,
    Class? classData,
    LessonStatus? status,
  }) {
    return LessonState(
      lessonData: lessonData ?? this.lessonData,
      classData: classData ?? this.classData,
      status: status ?? this.status,
    );
  }
}

