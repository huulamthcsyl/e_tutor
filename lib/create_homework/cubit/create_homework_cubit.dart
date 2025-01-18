import 'package:class_repository/class_repository.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'create_homework_state.dart';

class CreateHomeworkCubit extends Cubit<CreateHomeworkState> {

  final ClassRepository _classRepository;

  CreateHomeworkCubit(this._classRepository) : super(const CreateHomeworkState());

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

  void submit(String classId, String lessonId) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _classRepository.createHomework(
        classId,
        lessonId,
        Homework(
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
