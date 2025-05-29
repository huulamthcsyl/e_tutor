import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

part 'homework_detail_state.dart';

class HomeworkCubit extends Cubit<HomeworkState> {

  final ClassRepository _classRepository;
  final AuthenticationRepository _authenticationRepository;
  final ProfileRepository _profileRepository;

  HomeworkCubit(this._classRepository, this._profileRepository, this._authenticationRepository) : super(const HomeworkState());

  void initialize(String id) async {
    emit(state.copyWith(status: HomeworkStatus.loading));
    final homework = await _classRepository.getHomework(id);
    final user = await _authenticationRepository.user.first;
    final profile = await _profileRepository.getProfile(user.id);
    emit(state.copyWith(
      homework: homework,
      user: profile,
      studentWorks: homework.studentWorks,
      status: HomeworkStatus.success
    ));
  }

  void uploadStudentWork() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (file != null) {
      emit(state.copyWith(status: HomeworkStatus.loading));
      final path = await _classRepository.uploadStudentWork(
        state.homework.id!,
        file.files.first.name,
        file.files.first.bytes!,
      );
      final studentWork = Material(
        name: file.files.first.name,
        url: path,
      );
      final studentWorks = [...state.studentWorks, studentWork];
      emit(state.copyWith(studentWorks: studentWorks, status: HomeworkStatus.success));
    }
  }

  void submit() async {
    emit(state.copyWith(status: HomeworkStatus.loading));
    await _classRepository.submitHomework(
      state.homework.id!,
      state.studentWorks
    );
    emit(state.copyWith(status: HomeworkStatus.success));
  }

  void deleteStudentWork(Material material) {
    emit(state.copyWith(status: HomeworkStatus.loading));
    final studentWorks = state.studentWorks.where((work) => work != material).toList();
    emit(state.copyWith(studentWorks: studentWorks, status: HomeworkStatus.success));
  }
}
