import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

part 'class_detail_state.dart';

class ClassDetailCubit extends Cubit<ClassDetailState> {

  final ClassRepository _classRepository;
  final ProfileRepository _profileRepository;

  ClassDetailCubit(this._classRepository, this._profileRepository) : super(const ClassDetailState());

  void fetchClassDetail(String id) async {
    emit(state.copyWith(status: ClassDetailStatus.loading));
    try {
      final classDetail = await _classRepository.getClass(id);
      final members = await _profileRepository.getProfilesByIds(classDetail.members ?? []);
      emit(state.copyWith(
        status: ClassDetailStatus.success,
        classDetail: classDetail,
        members: members,
      ));
    } catch (e) {
      emit(state.copyWith(status: ClassDetailStatus.failure));
    }
  }
}
