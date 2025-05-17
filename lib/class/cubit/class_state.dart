part of 'class_cubit.dart';

enum ClassStatus { initial, loading, success, failure }

final class ClassState extends Equatable {

  final List<Class> classes;
  final ClassStatus status;
  final Profile user;

  const ClassState({
    this.status = ClassStatus.initial,
    this.classes = const [],
    this.user = const Profile(
      id: '',
    ),
  });

  @override
  List<Object> get props => [status, classes, user];

  ClassState copyWith({
    ClassStatus? status,
    List<Class>? classes,
    Profile? user,
  }) {
    return ClassState(
      status: status ?? this.status,
      classes: classes ?? this.classes,
      user: user ?? this.user,
    );
  }
}
