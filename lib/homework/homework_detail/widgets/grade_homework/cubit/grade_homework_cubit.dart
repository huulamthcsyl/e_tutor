import 'package:bloc/bloc.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/utils/notification_util.dart';
import 'package:equatable/equatable.dart';

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

  void gradeHomework() async {
    await _classRepository.gradeHomework(
      state.homework.id!,
      state.score,
      state.feedback,
    );
    await NotificationService().sendNotificationToClass(
      classId: state.homework.classId!,
      title: 'Trả điểm bài tập',
      body: 'Bài tập ${state.homework.title} đã được trả điểm',
      documentId: state.homework.id!,
      documentType: 'homework',
    );
  }
}
