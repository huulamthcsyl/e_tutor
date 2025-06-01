import 'package:bloc/bloc.dart';
import 'package:class_repository/class_repository.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:profile_repository/profile_repository.dart';

import '../../../utils/auth_util.dart';

part 'class_exam_state.dart';

class ClassExamCubit extends Cubit<ClassExamState> {

  final ClassRepository _classRepository;

  ClassExamCubit(this._classRepository) : super(const ClassExamState());

  void initialize(String classId) async {
    emit(state.copyWith(status: ClassExamStatus.loading));
    try {
      final startTime = DateTime.now().subtract(const Duration(days: 15));
      final endTime = DateTime.now().add(const Duration(days: 15));
      final exams = await _classRepository.getExamsInRange(classId, startTime, endTime);
      final user = await AuthService().getCurrentUserProfile();
      emit(state.copyWith(
        classId: classId,
        status: ClassExamStatus.loaded,
        exams: exams,
        startTime: startTime,
        endTime: endTime,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(status: ClassExamStatus.error));
    }
  }

  void updateRange(DateTime startTime, DateTime endTime) async {
    emit(state.copyWith(status: ClassExamStatus.loading));
    try {
      final exams = await _classRepository.getExamsInRange(state.classId, startTime, endTime);
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
}
