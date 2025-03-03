part of 'lesson_cubit.dart';

enum LessonStatus { initial, loading, success, failure }

class LessonState extends Equatable {

  final Lesson lessonData;
  final Class classData;
  final LessonStatus status;
  final List<Homework> homeworks;
  final User user;
  final Profile profile;

  const LessonState({
    this.lessonData = const Lesson(
      classId: '',
      homeworks: [],
      materials: [],
    ),
    this.classData = const Class(),
    this.status = LessonStatus.initial,
    this.homeworks = const [],
    this.user = const User(id: ''),
    this.profile = const Profile(id: ''),
  });

  @override
  List<Object> get props => [lessonData, classData, status, homeworks, user, profile];

  LessonState copyWith({
    Lesson? lessonData,
    Class? classData,
    LessonStatus? status,
    List<Homework>? homeworks,
    User? user,
    Profile? profile,
  }) {
    return LessonState(
      lessonData: lessonData ?? this.lessonData,
      classData: classData ?? this.classData,
      status: status ?? this.status,
      homeworks: homeworks ?? this.homeworks,
      user: user ?? this.user,
      profile: profile ?? this.profile,
    );
  }
}

