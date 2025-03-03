part of 'class_cubit.dart';

enum ClassStatus { initial, loading, success, failure }

final class ClassState extends Equatable {

  final List<Class> classes;
  final ClassStatus status;
  final Profile profile;

  const ClassState({
    this.status = ClassStatus.initial,
    this.classes = const [],
    this.profile = const Profile(id: '')
  });

  @override
  List<Object> get props => [status, classes, profile];

  ClassState copyWith({
    ClassStatus? status,
    List<Class>? classes,
    Profile? profile
  }) {
    return ClassState(
      status: status ?? this.status,
      classes: classes ?? this.classes,
      profile: profile ?? this.profile
    );
  }
}
