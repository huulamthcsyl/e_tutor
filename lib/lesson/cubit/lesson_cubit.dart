import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lesson_state.dart';

class LessonCubit extends Cubit<LessonState> {

  final ClassRepository _classRepository;

  LessonCubit(
    this._classRepository,
  ) : super(const LessonState());
  
  Future<void> initialize(String classId, String lessonId) async {
    emit(state.copyWith(status: LessonStatus.loading));
    try {
      final lessonData = await _classRepository.getLesson(classId, lessonId);
      final classData = await _classRepository.getClass(classId);
      final homeworks = await _classRepository.getHomeworks(lessonData.homeworks);
      emit(state.copyWith(
        lessonData: lessonData, 
        classData: classData, 
        homeworks: homeworks,
        status: LessonStatus.success,
      ));
    } on ClassFailure {
      emit(state.copyWith(status: LessonStatus.failure));
    }
  }

  Future<void> reloadHomeworks(String classId, String lessonId) async {
    emit(state.copyWith(status: LessonStatus.loading));
    try {
      final lessonData = await _classRepository.getLesson(classId, lessonId);
      final homeworks = await _classRepository.getHomeworks(lessonData.homeworks);
      emit(state.copyWith(lessonData: lessonData, homeworks: homeworks, status: LessonStatus.success));
    } on ClassFailure {
      emit(state.copyWith(status: LessonStatus.failure));
    }
  }

  Future<void> getClassInfo(String id) async {
    emit(state.copyWith(status: LessonStatus.loading));
    try {
      final classData = await _classRepository.getClass(id);
      emit(state.copyWith(classData: classData, status: LessonStatus.success));
    } on ClassFailure {
      emit(state.copyWith(status: LessonStatus.failure));
    }
  }

  Future<void> getHomeworks(List<String> homeworkIds) async {
    emit(state.copyWith(status: LessonStatus.loading));
    try {
      final homeworks = await _classRepository.getHomeworks(homeworkIds);
      emit(state.copyWith(homeworks: homeworks, status: LessonStatus.success));
    } on ClassFailure {
      emit(state.copyWith(status: LessonStatus.failure));
    }
  }

  Future<void> uploadMaterial() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    emit(state.copyWith(status: LessonStatus.loading));
    if (file != null) {
      await _classRepository.uploadLessonMaterial(
        state.classData.id!,
        state.lessonData,
        file.files.first.name,
        file.files.first.bytes!,
      );
      await reloadHomeworks(state.classData.id!, state.lessonData.id!);
    }
  }
}
