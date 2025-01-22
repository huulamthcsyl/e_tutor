part of 'homework_cubit.dart';

enum HomeworkStatus { initial, loading, success, failure }

class HomeworkState extends Equatable {

  final Homework homework;
  final HomeworkStatus status;

  const HomeworkState({
    this.homework = const Homework(
      id: '',
      title: '',
    ),
    this.status = HomeworkStatus.initial,
  });

  @override
  List<Object> get props => [homework, status];

  HomeworkState copyWith({
    Homework? homework,
    HomeworkStatus? status,
  }) {
    return HomeworkState(
      homework: homework ?? this.homework,
      status: status ?? this.status,
    );
  }
}

