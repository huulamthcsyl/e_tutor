import 'package:bloc/bloc.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/utils/notification_service.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'grade_exam_state.dart';

class GradeExamCubit extends Cubit<GradeExamState> {

  final ClassRepository _classRepository;

  GradeExamCubit(this._classRepository) : super(const GradeExamState());

  void initialize(Exam exam) {
    emit(state.copyWith(exam: exam));
  }

  void scoreChanged(double value) {
    emit(state.copyWith(score: value));
  }

  void feedbackChanged(String value) {
    emit(state.copyWith(feedback: value));
  }

  void gradeExam() async {
    await _classRepository.gradeExam(
      state.exam.id!,
      state.score,
      state.feedback,
    );
    await NotificationService().sendNotificationToClass(
      classId: state.exam.classId!,
      title: 'Trả điểm bài kiểm tra',
      body: 'Bài kiểm tra ${state.exam.title} đã được trả điểm',
      documentId: state.exam.id!,
      documentType: 'exam',
    );
  }
}
