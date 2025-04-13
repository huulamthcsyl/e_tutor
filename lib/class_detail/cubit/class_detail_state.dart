part of 'class_detail_cubit.dart';

enum ClassDetailStatus { initial, loading, success, failure }

class ClassDetailState extends Equatable {

  final Class classDetail;
  final ClassDetailStatus status;
  final List<Profile> members;
  final LessonResponse upcomingLesson;
  final Profile user;

  const ClassDetailState({
    this.classDetail = const Class(),
    this.status = ClassDetailStatus.initial,
    this.members = const [],
    this.upcomingLesson = const LessonResponse(),
    this.user = const Profile(
      id: '',
    ),
  });

  @override
  List<Object> get props => [classDetail, status, members, upcomingLesson, user];

  ClassDetailState copyWith({
    Class? classDetail,
    ClassDetailStatus? status,
    List<Profile>? members,
    LessonResponse? upcomingLesson,
    Profile? user,
  }) {
    return ClassDetailState(
      classDetail: classDetail ?? this.classDetail,
      status: status ?? this.status,
      members: members ?? this.members,
      upcomingLesson: upcomingLesson ?? this.upcomingLesson,
      user: user ?? this.user,
    );
  }
}
