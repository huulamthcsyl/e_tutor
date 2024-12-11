import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';

part 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  final ClassRepository _classRepository;

  ClassCubit(this._classRepository) : super(const ClassState());

  Future<void> getClasses() async {
    emit(state.copyWith(status: ClassStatus.loading));
    try {
      final classes = await _classRepository.getClasses();
      emit(state.copyWith(status: ClassStatus.success, classes: classes));
    } catch (e) {
      emit(state.copyWith(status: ClassStatus.failure));
    }
  }
}
