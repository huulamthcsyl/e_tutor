part of 'class_detail_cubit.dart';

enum ClassDetailStatus { initial, loading, success, failure }

class ClassDetailState extends Equatable {

  final Class classDetail;
  final ClassDetailStatus status;
  final List<Profile> members;

  const ClassDetailState({
    this.classDetail = const Class(),
    this.status = ClassDetailStatus.initial,
    this.members = const [],
  });

  @override
  List<Object> get props => [classDetail, status, members];

  ClassDetailState copyWith({
    Class? classDetail,
    ClassDetailStatus? status,
    List<Profile>? members,
  }) {
    return ClassDetailState(
      classDetail: classDetail ?? this.classDetail,
      status: status ?? this.status,
      members: members ?? this.members,
    );
  }
}
