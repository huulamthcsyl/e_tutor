part of 'create_exam_cubit.dart';

class CreateExamState extends Equatable {

  final String classId;
  final String title;
  final List<Material> materials;
  final DateTime startTime;
  final DateTime endTime;

  const CreateExamState({
    this.classId = '',
    this.title = '',
    this.materials = const [],
    this.startTime = const ConstDateTime(0),
    this.endTime = const ConstDateTime(0),
  });

  @override
  List<Object?> get props => [classId, title, materials, startTime, endTime];

  CreateExamState copyWith({
    String? classId,
    String? title,
    List<Material>? materials,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return CreateExamState(
      classId: classId ?? this.classId,
      title: title ?? this.title,
      materials: materials ?? this.materials,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
