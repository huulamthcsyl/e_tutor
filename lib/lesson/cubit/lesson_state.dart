part of 'lesson_cubit.dart';

enum LessonStatus { initial, loading, success, failure }

class LessonState extends Equatable {

  final Lesson lessonData;
  final Class classData;
  final LessonStatus status;
  final List<Homework> homeworks;
  final Profile user;

  const LessonState({
    this.lessonData = const Lesson(
      classId: '',
      homeworks: [],
      materials: [],
    ),
    this.classData = const Class(),
    this.status = LessonStatus.initial,
    this.homeworks = const [],
    this.user = const Profile(
      id: '',
    ),
  });

  @override
  List<Object> get props => [lessonData, classData, status, homeworks, user];

  LessonState copyWith({
    Lesson? lessonData,
    Class? classData,
    LessonStatus? status,
    List<Homework>? homeworks,
    Profile? user,
  }) {
    return LessonState(
      lessonData: lessonData ?? this.lessonData,
      classData: classData ?? this.classData,
      status: status ?? this.status,
      homeworks: homeworks ?? this.homeworks,
      user: user ?? this.user,
    );
  }
}

