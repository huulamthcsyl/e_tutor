part of 'lesson_cubit.dart';

enum LessonStatus { initial, loading, success, failure }

class LessonState extends Equatable {

  final Lesson lessonData;
  final Class classData;
  final LessonStatus status;
  final List<Material> materials;

  const LessonState({
    this.lessonData = const Lesson(),
    this.classData = const Class(),
    this.status = LessonStatus.initial,
    this.materials = const [],
  });

  @override
  List<Object> get props => [lessonData, classData, materials, status];

  LessonState copyWith({
    Lesson? lessonData,
    Class? classData,
    List<Material>? materials,
    LessonStatus? status,
  }) {
    return LessonState(
      lessonData: lessonData ?? this.lessonData,
      classData: classData ?? this.classData,
      materials: materials ?? this.materials,
      status: status ?? this.status,
    );
  }
}

