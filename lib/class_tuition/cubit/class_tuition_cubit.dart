import 'package:bloc/bloc.dart';
import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';

part 'class_tuition_state.dart';

class ClassTuitionCubit extends Cubit<ClassTuitionState> {
  final ClassRepository classRepository;

  ClassTuitionCubit(this.classRepository) : super(const ClassTuitionState());

  void initialize(String classId) async {
    emit(state.copyWith(status: ClassTuitionStatus.loading));
    try {
      final lessons = await classRepository.getUnpaidLessons(classId);
      final classData = await classRepository.getClass(classId);
      
      emit(state.copyWith(
        classId: classId,
        status: ClassTuitionStatus.success,
        lessons: lessons,
        classData: classData,
      ));
    } catch (e) {
      emit(state.copyWith(status: ClassTuitionStatus.failure));
    }
  }

  void toggleLessonSelection(String lessonId) {
    final newSelectedLessons = Set<String>.from(state.selectedLessons);
    if (newSelectedLessons.contains(lessonId)) {
      newSelectedLessons.remove(lessonId);
    } else {
      newSelectedLessons.add(lessonId);
    }
    emit(state.copyWith(selectedLessons: newSelectedLessons));
  }

  void toggleSelectAll() {
    if (state.isAllSelected) {
      // If all are selected, deselect all
      emit(state.copyWith(selectedLessons: {}));
    } else {
      // If not all are selected, select all
      final allLessonIds = state.lessons.map((lesson) => lesson.id!).toSet();
      emit(state.copyWith(selectedLessons: allLessonIds));
    }
  }
}
