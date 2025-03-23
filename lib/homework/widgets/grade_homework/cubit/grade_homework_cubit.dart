import 'package:bloc/bloc.dart';
import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'grade_homework_state.dart';

class GradeHomeworkCubit extends Cubit<GradeHomeworkState> {

  final ClassRepository _classRepository;

  GradeHomeworkCubit(this._classRepository) : super(const GradeHomeworkState());

  void initialize(Homework homework) {
    emit(state.copyWith(homework: homework));
  }

  void scoreChanged(double value) {
    emit(state.copyWith(score: value));
  }

  void feedbackChanged(String value) {
    emit(state.copyWith(feedback: value));
  }

  void gradeHomework() {
    _classRepository.gradeHomework(
      state.homework.id!,
      state.score,
      state.feedback,
    );
  }
}
