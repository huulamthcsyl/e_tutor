import 'package:bloc/bloc.dart';
import 'package:class_repository/class_repository.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

part 'create_lesson_state.dart';

class CreateLessonCubit extends Cubit<CreateLessonState> {

  final ClassRepository _classRepository;

  CreateLessonCubit(this._classRepository) : super(const CreateLessonState());

  void init(String classId) {
    final startDate = DateTime.now();
    final endDate = DateTime.now().add(const Duration(hours: 2));
    emit(state.copyWith(classId: classId, startDate: startDate, endDate: endDate));
  }

  void startTimeChanged(DateTime date) {
    emit(state.copyWith(startDate: date, endDate: date.add(const Duration(hours: 2))));
  }

  void endTimeChanged(DateTime date) {
    emit(state.copyWith(endDate: date));
  }

  void submit(BuildContext context) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _classRepository.createLesson(
        state.classId,
        state.startTime,
        state.endTime
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
