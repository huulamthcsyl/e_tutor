import 'package:bloc/bloc.dart';
import 'package:class_repository/class_repository.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';

part 'class_exam_state.dart';

class ClassExamCubit extends Cubit<ClassExamState> {

  final ClassRepository _classRepository;

  ClassExamCubit(this._classRepository) : super(const ClassExamState());

  void initialize(String classId) async {
    emit(state.copyWith(status: ClassExamStatus.loading));
    try {
      final startTime = DateTime.now().subtract(const Duration(days: 30));
      final endTime = DateTime.now();
      final exams = await _classRepository.getExamsInRange(classId, startTime, endTime);
      emit(state.copyWith(
        status: ClassExamStatus.loaded,
        exams: exams,
        startTime: startTime,
        endTime: endTime,
      ));
    } catch (e) {
      emit(state.copyWith(status: ClassExamStatus.error));
    }
  }

  void startTimeChanged(DateTime startTime) {
    emit(state.copyWith(startTime: startTime));
  }

  void endTimeChanged(DateTime endTime) {
    emit(state.copyWith(endTime: endTime));
  }
}
