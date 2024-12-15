part of 'class_cubit.dart';

enum ClassStatus { initial, loading, success, failure }

final class ClassState extends Equatable {

  final List<Class> classes;
  final ClassStatus status;

  const ClassState({
    this.status = ClassStatus.initial,
    this.classes = const [],
  });

  @override
  List<Object> get props => [status, classes];

  ClassState copyWith({
    ClassStatus? status,
    List<Class>? classes,
  }) {
    return ClassState(
      status: status ?? this.status,
      classes: classes ?? this.classes,
    );
  }
}
