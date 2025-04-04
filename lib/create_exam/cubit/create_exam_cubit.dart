import 'package:bloc/bloc.dart';
import 'package:class_repository/class_repository.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';

part 'create_exam_state.dart';

class CreateExamCubit extends Cubit<CreateExamState> {

  final ClassRepository _classRepository;

  CreateExamCubit(this._classRepository) : super(const CreateExamState());

  void initialize(String? classId) {
    if (classId != null) {
      emit(state.copyWith(classId: classId));
    }
  }
}
