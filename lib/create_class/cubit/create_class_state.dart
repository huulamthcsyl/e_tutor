part of 'create_class_cubit.dart';

class CreateClassState extends Equatable {
  final RequiredText name;
  final String description;
  final RequiredText tuition;
  final bool isValid;
  final FormzSubmissionStatus status;
  final List<Schedule> schedules;

  const CreateClassState({
    this.name = const RequiredText.pure(),
    this.description = '',
    this.tuition = const RequiredText.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
    this.schedules = const [],
  });

  @override
  List<Object> get props =>
      [name, description, tuition, isValid, status, schedules];

  CreateClassState copyWith({
    RequiredText? name,
    String? description,
    RequiredText? tuition,
    bool? isValid,
    FormzSubmissionStatus? status,
    List<Schedule>? schedules,
    Schedule? newSchedule,
  }) {
    return CreateClassState(
      name: name ?? this.name,
      description: description ?? this.description,
      tuition: tuition ?? this.tuition,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      schedules: schedules ?? this.schedules,
    );
  }
}
