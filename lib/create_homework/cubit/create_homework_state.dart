part of 'create_homework_cubit.dart';

class CreateHomeworkState extends Equatable {
  final RequiredText title;
  final List<Material> materials;
  final DateTime dueDate;
  final FormzSubmissionStatus status;
  final bool isValid;

  const CreateHomeworkState({
    this.title = const RequiredText.pure(),
    this.materials = const [],
    this.dueDate = const ConstDateTime(2026),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
  });

  @override
  List<Object> get props => [title, materials, dueDate, status, isValid];

  CreateHomeworkState copyWith({
    RequiredText? title,
    List<Material>? materials,
    DateTime? dueDate,
    FormzSubmissionStatus? status,
    bool? isValid,
  }) {
    return CreateHomeworkState(
      title: title ?? this.title,
      materials: materials ?? this.materials,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
    );
  }
}
