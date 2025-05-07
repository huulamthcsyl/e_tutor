part of 'class_tuition_cubit.dart';

enum ClassTuitionStatus { initial, loading, success, failure }

class ClassTuitionState extends Equatable {

  final String classId;
  final Class? classData;
  final List<Lesson> lessons;
  final ClassTuitionStatus status;
  final Set<String> selectedLessons;

  const ClassTuitionState({
    this.classId = '',
    this.classData,
    this.lessons = const [],
    this.status = ClassTuitionStatus.initial,
    this.selectedLessons = const {},
  });

  int get totalTuition {
    if (classData?.tuition == null) return 0;
    return classData!.tuition! * selectedLessons.length;
  }

  bool get isAllSelected => selectedLessons.length == lessons.length;

  @override
  List<Object?> get props => [classId, classData, lessons, status, selectedLessons];

  ClassTuitionState copyWith({
    String? classId,
    Class? classData,
    List<Lesson>? lessons,
    ClassTuitionStatus? status,
    Set<String>? selectedLessons,
  }) {
    return ClassTuitionState(
      classId: classId ?? this.classId,
      classData: classData ?? this.classData,
      lessons: lessons ?? this.lessons,
      status: status ?? this.status,
      selectedLessons: selectedLessons ?? this.selectedLessons,
    );
  }
}
