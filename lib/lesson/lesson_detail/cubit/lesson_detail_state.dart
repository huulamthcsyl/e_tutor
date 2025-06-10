part of 'lesson_detail_cubit.dart';

enum LessonStatus { initial, loading, success, failure }

enum UploadStatus { initial, loading, success, failure }

class LessonState extends Equatable {

  final Lesson lessonData;
  final Class classData;
  final LessonStatus status;
  final List<Homework> homeworks;
  final Profile user;
  final bool isCancelled;
  final UploadStatus uploadStatus;

  const LessonState({
    this.lessonData = const Lesson(
      classId: '',
      homeworks: [],
      materials: [],
    ),
    this.classData = const Class(),
    this.status = LessonStatus.initial,
    this.homeworks = const [],
    this.user = const Profile(
      id: '',
    ),
    this.isCancelled = false,
    this.uploadStatus = UploadStatus.initial,
  });

  @override
  List<Object> get props => [lessonData, classData, status, homeworks, user, isCancelled, uploadStatus];

  LessonState copyWith({
    Lesson? lessonData,
    Class? classData,
    LessonStatus? status,
    List<Homework>? homeworks,
    Profile? user,
    bool? isCancelled,
    UploadStatus? uploadStatus,
  }) {
    return LessonState(
      lessonData: lessonData ?? this.lessonData,
      classData: classData ?? this.classData,
      status: status ?? this.status,
      homeworks: homeworks ?? this.homeworks,
      user: user ?? this.user,
      isCancelled: isCancelled ?? this.isCancelled,
      uploadStatus: uploadStatus ?? this.uploadStatus,
    );
  }
}

