part of 'grade_homework_cubit.dart';

class GradeHomeworkState extends Equatable {
  final Homework homework;
  final double score;
  final String feedback;

  const GradeHomeworkState({
    this.homework = const Homework(
      id: '',
      title: '',
    ),
    this.score = 0,
    this.feedback = '',
  });

  @override
  List<Object> get props => [homework, score, feedback];

  GradeHomeworkState copyWith({
    Homework? homework,
    double? score,
    String? feedback,
  }) {
    return GradeHomeworkState(
      homework: homework ?? this.homework,
      score: score ?? this.score,
      feedback: feedback ?? this.feedback,
    );
  }
}

