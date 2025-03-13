import 'package:class_repository/class_repository.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:random_string/random_string.dart';

part 'create_homework_state.dart';

class CreateHomeworkCubit extends Cubit<CreateHomeworkState> {

  final ClassRepository _classRepository;

  CreateHomeworkCubit(this._classRepository) : super(const CreateHomeworkState());

  void initialize(String? classId, String? lessonId) {
    emit(state.copyWith(
      classId: classId,
      lessonId: lessonId,
      homeworkId: randomAlphaNumeric(20)
    ));
  }

  void updateTitle(String title) {
    final titleInput = RequiredText.dirty(title);
    emit(state.copyWith(
      title: titleInput,
      isValid: Formz.validate([titleInput]),
    ));
  }

  void updateMaterials(List<Material> materials) {
    emit(state.copyWith(materials: materials));
  }
  
  void updateDueDate(DateTime dueDate) {
    emit(state.copyWith(dueDate: dueDate));
  }

  Future<void> uploadMaterial() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (file != null) {
      final path = await _classRepository.uploadHomeworkMaterial(
        state.classId,
        state.lessonId,
        state.homeworkId,
        file.files.first.name,
        file.files.first.bytes!,
      );
      final material = Material(
        name: file.files.first.name,
        url: path,
      );
      emit(state.copyWith(
        materials: [...state.materials, material],
      ));
    }
  }

  void submit() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _classRepository.createHomework(
        state.classId,
        state.lessonId,
        Homework(
          id: state.homeworkId,
          title: state.title.value,
          materials: state.materials,
          dueDate: state.dueDate,
        ),
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on ClassFailure {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
