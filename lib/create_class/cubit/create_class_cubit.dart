import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:const_date_time/const_date_time.dart';

part 'create_class_state.dart';

class CreateClassCubit extends Cubit<CreateClassState> {
  final ClassRepository _classRepository;
  final AuthenticationRepository _authenticationRepository;

  CreateClassCubit(this._classRepository, this._authenticationRepository) : super(const CreateClassState());

  void nameChanged(String value) {
    final name = RequiredText.dirty(value);
    emit(state.copyWith(
      name: name,
      isValid: Formz.validate([name, state.tuition]),
    ));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(
      description: value,
    ));
  }

  void tuitionChanged(String value) {
    final tuition = RequiredText.dirty(value);
    emit(state.copyWith(
      tuition: tuition,
      isValid: Formz.validate([tuition, state.name]),
    ));
  }

  void addSchedule(TimeOfDay startTime, TimeOfDay endTime, DayInWeek day) {
    final schedule = Schedule(
      startTime: startTime,
      endTime: endTime,
      day: day
    );
    emit(state.copyWith(
      schedules: List.of(state.schedules)..add(schedule),
    ));
  }

  void removeSchedule(Schedule schedule) {
    emit(state.copyWith(
      schedules: List.of(state.schedules)..remove(schedule),
    ));
  }

  void startDateChanged(DateTime value) {
    emit(state.copyWith(
      startDate: value,
    ));
  }

  void endDateChanged(DateTime value) {
    emit(state.copyWith(
      endDate: value,
    ));
  }

  void createClass() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final user = await _authenticationRepository.user.first;
    try {
      await _classRepository.createClass(
        Class(
          name: state.name.value,
          description: state.description,
          tuition: int.parse(state.tuition.value),
          schedules: state.schedules,
          members: [user.id],
          createdAt: DateTime.now(),
          startDate: state.startDate,
          endDate: state.endDate
        ),
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on Exception {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
