part of 'exam_cubit.dart';

enum ExamStatus {
  initial,
  loading,
  success,
  failure,
}

enum ActionStatus {
  notStarted,
  todo,
  inProgress,
  ended,
}

enum UploadStatus {
  initial,
  uploading,
  uploaded,
}

class ExamState extends Equatable {

  final Exam exam;
  final ExamStatus status;
  final ActionStatus actionStatus;
  final List<Material> studentWorks;
  final FormzSubmissionStatus submissionStatus;
  final Profile user;
  final UploadStatus uploadStatus;

  const ExamState({
    this.exam = const Exam(),
    this.status = ExamStatus.initial,
    this.actionStatus = ActionStatus.todo,
    this.studentWorks = const [],
    this.submissionStatus = FormzSubmissionStatus.initial,
    this.user = const Profile(
      id: '',
    ),
    this.uploadStatus = UploadStatus.initial,
  });

  @override
  List<Object> get props => [exam, status, actionStatus, studentWorks, submissionStatus, user, uploadStatus];

  ExamState copyWith({
    Exam? exam,
    ExamStatus? status,
    ActionStatus? actionStatus,
    List<Material>? studentWorks,
    FormzSubmissionStatus? submissionStatus,
    Profile? user,
    UploadStatus? uploadStatus,
  }) {
    return ExamState(
      exam: exam ?? this.exam,
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      studentWorks: studentWorks ?? this.studentWorks,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      user: user ?? this.user,
      uploadStatus: uploadStatus ?? this.uploadStatus,
    );
  }
}

