part of 'create_exam_cubit.dart';

class CreateExamState extends Equatable {

  final String classId;
  final String examId;
  final RequiredText title;
  final List<Material> materials;
  final DateTime startTime;
  final DateTime endTime;
  final bool isValid;
  final FormzSubmissionStatus status;

  const CreateExamState({
    this.classId = '',
    this.examId = '',
    this.title = const RequiredText.pure(),
    this.materials = const [],
    this.startTime = const ConstDateTime(0),
    this.endTime = const ConstDateTime(0),
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
  });

  @override
  List<Object?> get props => [classId, examId, title, materials, startTime, endTime, isValid, status];

  CreateExamState copyWith({
    String? classId,
    String? examId,
    RequiredText? title,
    List<Material>? materials,
    DateTime? startTime,
    DateTime? endTime,
    bool? isValid,
    FormzSubmissionStatus? status,
  }) {
    return CreateExamState(
      classId: classId ?? this.classId,
      examId: examId ?? this.examId,
      title: title ?? this.title,
      materials: materials ?? this.materials,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
    );
  }
}
