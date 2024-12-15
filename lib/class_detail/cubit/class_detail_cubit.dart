import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'class_detail_state.dart';

class ClassDetailCubit extends Cubit<ClassDetailState> {

  final ClassRepository _classRepository;

  ClassDetailCubit(this._classRepository) : super(const ClassDetailState());

  void fetchClassDetail(String id) async {
    emit(state.copyWith(status: ClassDetailStatus.loading));
    try {
      final classDetail = await _classRepository.getClass(id);
      emit(state.copyWith(
        status: ClassDetailStatus.success,
        classDetail: classDetail,
      ));
    } catch (e) {
      emit(state.copyWith(status: ClassDetailStatus.failure));
    }
  }
}
