part of 'homework_cubit.dart';

enum HomeworkStatus { initial, loading, success, failure }

class HomeworkState extends Equatable {

  final Homework homework;
  final HomeworkStatus status;
  final Profile user;
  final List<Material> studentWorks;

  const HomeworkState({
    this.homework = const Homework(
      id: '',
      title: '',
    ),
    this.status = HomeworkStatus.initial,
    this.user = const Profile(
      id: '',
    ),
    this.studentWorks = const [],
  });

  @override
  List<Object> get props => [homework, status, user, studentWorks];

  HomeworkState copyWith({
    Homework? homework,
    HomeworkStatus? status,
    Profile? user,
    List<Material>? studentWorks,
  }) {
    return HomeworkState(
      homework: homework ?? this.homework,
      status: status ?? this.status,
      user: user ?? this.user,
      studentWorks: studentWorks ?? this.studentWorks,
    );
  }
}

