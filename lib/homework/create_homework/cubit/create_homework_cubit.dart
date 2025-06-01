import 'package:class_repository/class_repository.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:e_tutor/utils/notification_util.dart';
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

  void initialize(String? classId, String? lessonId, Homework? homework, String? className) {
    emit(state.copyWith(
      classId: classId ?? '',
      lessonId: lessonId ?? '',
      homeworkId: homework?.id ?? randomAlphaNumeric(20),
      title: homework != null ? RequiredText.dirty(homework.title) : const RequiredText.pure(),
      materials: homework?.materials ?? [],
      dueDate: homework?.dueDate ?? DateTime.now(),
      isValid: Formz.validate([homework != null ? RequiredText.dirty(homework.title) : const RequiredText.pure()]),
      className: className,
      isCreate: homework == null,
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
      emit(state.copyWith(uploadStatus: UploadStatus.uploading));
      final path = await _classRepository.uploadHomeworkMaterial(
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
        uploadStatus: UploadStatus.uploaded,
      ));
    }
  }

  void deleteMaterial(Material material) {
    emit(state.copyWith(materials: state.materials.where((m) => m.url != material.url).toList()));
  }

  void submit() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      if (state.isCreate) {
        await _classRepository.createHomework(
          state.classId,
          state.lessonId,
          Homework(
            id: state.homeworkId,
            title: state.title.value,
            materials: state.materials,
            dueDate: state.dueDate,
            createdAt: DateTime.now(),
          ),
        );
        await NotificationService().sendNotificationToClass(
          classId: state.classId,
          title: 'Bài tập mới',
          body: 'Bài tập ${state.title.value} đã được thêm cho lớp ${state.className}',
          documentId: state.homeworkId,
          documentType: 'homework',
        );
      } else {
        await _classRepository.updateHomework(
          state.homeworkId,
          Homework(
            title: state.title.value,
            materials: state.materials,
            dueDate: state.dueDate,
          ),
        );
      }
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on ClassFailure {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
