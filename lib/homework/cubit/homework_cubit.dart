import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

part 'homework_state.dart';

class HomeworkCubit extends Cubit<HomeworkState> {

  final ClassRepository _classRepository;
  final ProfileRepository _profileRepository;

  HomeworkCubit(this._classRepository, this._profileRepository) : super(const HomeworkState());

  void initialize(String id) async {
    emit(state.copyWith(status: HomeworkStatus.loading));
    final homework = await _classRepository.getHomework(id);
    emit(state.copyWith(homework: homework, status: HomeworkStatus.success));
  }
}
