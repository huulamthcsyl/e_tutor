part of 'class_detail_cubit.dart';

enum ClassDetailStatus { initial, loading, success, failure }

class ClassDetailState extends Equatable {

  final Class classDetail;
  final ClassDetailStatus status;
  final List<Profile> members;
  final LessonResponse upcomingLesson;
  final Profile user;
  final Exam recentExam;

  const ClassDetailState({
    this.classDetail = const Class(),
    this.status = ClassDetailStatus.initial,
    this.members = const [],
    this.upcomingLesson = const LessonResponse(),
    this.user = const Profile(
      id: '',
    ),
    this.recentExam = const Exam(),
  });

  @override
  List<Object> get props => [classDetail, status, members, upcomingLesson, recentExam, user];

  ClassDetailState copyWith({
    Class? classDetail,
    ClassDetailStatus? status,
    List<Profile>? members,
    LessonResponse? upcomingLesson,
    Profile? user,
    Exam? recentExam,
  }) {
    return ClassDetailState(
      classDetail: classDetail ?? this.classDetail,
      status: status ?? this.status,
      members: members ?? this.members,
      upcomingLesson: upcomingLesson ?? this.upcomingLesson,
      user: user ?? this.user,
      recentExam: recentExam ?? this.recentExam,
    );
  }
}
