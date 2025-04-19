import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/utils/notification_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:random_string/random_string.dart';

part 'create_class_state.dart';

class CreateClassCubit extends Cubit<CreateClassState> {
  final ClassRepository _classRepository;
  final AuthenticationRepository _authenticationRepository;
  final ProfileRepository _profileRepository;

  CreateClassCubit(this._classRepository, this._authenticationRepository, this._profileRepository) : super(const CreateClassState());

  void initialize() async {
    final startDate = DateTime.now();
    final endDate = DateTime.now().add(const Duration(days: 30));
    final classId = randomAlphaNumeric(20);
    final user = await _authenticationRepository.user.first;
    final profile = await _profileRepository.getProfile(user.id);
    emit(state.copyWith(
      classId: classId,
      startDate: startDate,
      endDate: endDate,
      schedules: [],
      status: FormzSubmissionStatus.initial,
      members: [profile],
    ));
  }

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

  void addMembers(List<Profile> members) {
    final currentMembersIds = state.members.map((e) => e.id).toList();
    final newMembers = members.where((member) => !currentMembersIds.contains(member.id)).toList();
    emit(state.copyWith(
      members: List.of(state.members)..addAll(newMembers),
    ));
  }

  void removeMember(Profile member) {
    emit(state.copyWith(
      members: List.of(state.members)..remove(member),
    ));
  }

  void createClass() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final memberIds = state.members.map((member) => member.id).toList();
    try {
      await _classRepository.createClass(
        Class(
          name: state.name.value,
          description: state.description,
          tuition: int.parse(state.tuition.value),
          schedules: state.schedules,
          members: memberIds,
          createdAt: DateTime.now(),
          startDate: state.startDate,
          endDate: state.endDate,
        ),
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      await NotificationService().sendNotifications(
        userIds: memberIds,
        title: 'Tạo lớp học mới',
        body: 'Bạn vừa được thêm vào lớp học ${state.name.value}',
        documentId: state.classId,
        documentType: 'class'
      );
    } on Exception {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
