part of 'grade_exam_cubit.dart';

class GradeExamState extends Equatable {
  final Exam exam;
  final double score;
  final String feedback;

  const GradeExamState({
    this.exam = const Exam(),
    this.score = 0,
    this.feedback = '',
  });

  @override
  List<Object> get props => [exam, score, feedback];

  GradeExamState copyWith({
    Exam? exam,
    double? score,
    String? feedback,
  }) {
    return GradeExamState(
      exam: exam ?? this.exam,
      score: score ?? this.score,
      feedback: feedback ?? this.feedback,
    );
  }
}

