import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:form_inputs/form_inputs.dart';

part 'create_class_state.dart';

class CreateClassCubit extends Cubit<CreateClassState> {
  final ClassRepository _classRepository;

  CreateClassCubit(this._classRepository) : super(const CreateClassState());

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

  void addSchedule(TimeOfDay startTime, TimeOfDay endTime) {
    final schedule = Schedule(
      startTime: startTime,
      endTime: endTime,
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

  void createClass() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _classRepository.createClass(
        Class(
          name: state.name.value,
          description: state.description,
          tuition: int.parse(state.tuition.value),
          schedules: state.schedules,
        ),
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on Exception {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
