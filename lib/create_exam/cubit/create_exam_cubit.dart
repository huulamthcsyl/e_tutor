import 'package:bloc/bloc.dart';
import 'package:class_repository/class_repository.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:random_string/random_string.dart';

part 'create_exam_state.dart';

class CreateExamCubit extends Cubit<CreateExamState> {

  final ClassRepository _classRepository;

  CreateExamCubit(this._classRepository) : super(const CreateExamState());

  void initialize(String classId) {
    final startTime = DateTime.now();
    final endTime = startTime.add(const Duration(hours: 1));
    final examId = randomAlphaNumeric(20);
    emit(state.copyWith(
      examId: examId,
      classId: classId,
      startTime: startTime,
      endTime: endTime,
    ));
  }

  void titleChanged(String title) {
    final titleInput = RequiredText.dirty(title);
    emit(state.copyWith(
      title: titleInput,
      isValid: Formz.validate([titleInput]),
    ));
  }

  void startTimeChanged(DateTime startTime) {
    emit(state.copyWith(startTime: startTime));
  }

  void endTimeChanged(DateTime endTime) {
    emit(state.copyWith(endTime: endTime));
  }

  void uploadMaterial() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (file != null) {
      final path = await _classRepository.uploadExamMaterial(
        state.examId,
        file.files.first.name,
        file.files.first.bytes!,
      );
      final material = Material(
        name: file.files.first.name,
        url: path,
      );
      emit(state.copyWith(materials: [...state.materials, material]));
    }
  }

  void submit() async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        final exam = Exam(
          id: state.examId,
          classId: state.classId,
          title: state.title.value,
          materials: state.materials,
          startTime: state.startTime,
          endTime: state.endTime,
        );
        await _classRepository.createExam(
          state.classId,
          exam,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
