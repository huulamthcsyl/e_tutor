part of 'create_class_cubit.dart';

class CreateClassState extends Equatable {
  final String classId;
  final RequiredText name;
  final String description;
  final RequiredText tuition;
  final bool isValid;
  final FormzSubmissionStatus status;
  final List<Schedule> schedules;
  final DateTime startDate;
  final DateTime endDate;
  final List<Profile> members;

  const CreateClassState({
    this.classId = '',
    this.name = const RequiredText.pure(),
    this.description = '',
    this.tuition = const RequiredText.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
    this.schedules = const [],
    this.endDate = const ConstDateTime(0),
    this.startDate = const ConstDateTime(0),
    this.members = const [],
  });

  @override
  List<Object> get props => [classId, name, description, tuition, isValid, status, schedules, endDate, startDate, members];

  CreateClassState copyWith({
    String? classId,
    RequiredText? name,
    String? description,
    RequiredText? tuition,
    bool? isValid,
    FormzSubmissionStatus? status,
    List<Schedule>? schedules,
    Schedule? newSchedule,
    DateTime? endDate,
    DateTime? startDate,
    List<Profile>? members,
  }) {
    return CreateClassState(
      classId: classId ?? this.classId,
      name: name ?? this.name,
      description: description ?? this.description,
      tuition: tuition ?? this.tuition,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      schedules: schedules ?? this.schedules,
      endDate: endDate ?? this.endDate,
      startDate: startDate ?? this.startDate,
      members: members ?? this.members,
    );
  }
}
