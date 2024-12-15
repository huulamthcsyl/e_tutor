part of 'class_detail_cubit.dart';

enum ClassDetailStatus { initial, loading, success, failure }

class ClassDetailState extends Equatable {

  final Class classDetail;
  final ClassDetailStatus status;

  const ClassDetailState({
    this.classDetail = const Class(),
    this.status = ClassDetailStatus.initial,
  });

  @override
  List<Object> get props => [classDetail, status];

  ClassDetailState copyWith({
    Class? classDetail,
    ClassDetailStatus? status,
  }) {
    return ClassDetailState(
      classDetail: classDetail ?? this.classDetail,
      status: status ?? this.status,
    );
  }
}
