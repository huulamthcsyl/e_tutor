part of 'create_homework_cubit.dart';

enum UploadStatus { initial, uploading, uploaded, failed }

class CreateHomeworkState extends Equatable {
  final String classId;
  final String lessonId;
  final String homeworkId;
  final RequiredText title;
  final List<Material> materials;
  final DateTime dueDate;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String className;
  final UploadStatus uploadStatus;
  final bool isCreate;

  const CreateHomeworkState({
    this.classId = '',
    this.lessonId = '',
    this.homeworkId = '',
    this.title = const RequiredText.pure(),
    this.materials = const [],
    this.dueDate = const ConstDateTime(2026),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.className = '',
    this.uploadStatus = UploadStatus.initial,
    this.isCreate = false,
  });

  @override
  List<Object> get props => [classId, lessonId, homeworkId, title, materials, dueDate, status, isValid, className, uploadStatus, isCreate];

  CreateHomeworkState copyWith({
    String? classId,
    String? lessonId,
    String? homeworkId,
    RequiredText? title,
    List<Material>? materials,
    DateTime? dueDate,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? className,
    UploadStatus? uploadStatus,
    bool? isCreate,
  }) {
    return CreateHomeworkState(
      classId: classId ?? this.classId,
      lessonId: lessonId ?? this.lessonId,
      homeworkId: homeworkId ?? this.homeworkId,
      title: title ?? this.title,
      materials: materials ?? this.materials,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      className: className ?? this.className,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      isCreate: isCreate ?? this.isCreate,
    );
  }
}
