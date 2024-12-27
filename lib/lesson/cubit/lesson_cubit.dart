import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lesson_state.dart';

class LessonCubit extends Cubit<LessonState> {

  final ClassRepository classRepository;

  LessonCubit({
    required this.classRepository,
  }) : super(const LessonState());

  Future<void> getClassInfo(String id) async {
    emit(state.copyWith(status: LessonStatus.loading));
    try {
      final classData = await classRepository.getClass(id);
      emit(state.copyWith(classData: classData, status: LessonStatus.success));
    } on ClassFailure {
      emit(state.copyWith(status: LessonStatus.failure));
    }
  }

  Future<void> uploadMaterial() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles();
  }
}
