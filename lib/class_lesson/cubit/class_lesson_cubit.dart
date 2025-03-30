import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:class_repository/class_repository.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:profile_repository/profile_repository.dart';

part 'class_lesson_state.dart';

class ClassLessonCubit extends Cubit<ClassLessonState> {

  final ClassRepository _classRepository;
  final AuthenticationRepository _authenticationRepository;
  final ProfileRepository _profileRepository;

  ClassLessonCubit(this._classRepository, this._authenticationRepository, this._profileRepository) : super(ClassLessonState());

  void initialize(String classId) async {
    emit(state.copyWith(status: ClassLessonStateStatus.loading));
    try {
      final startTime = DateTime.now();
      final endTime = DateTime.now().add(const Duration(days: 30));
      final lessons = await _classRepository.getLessonsInRange(classId, startTime, endTime);
      final user = await _authenticationRepository.user.first;
      final profile = await _profileRepository.getProfile(user.id);
      emit(state.copyWith(
        classId: classId,
        status: ClassLessonStateStatus.success,
        lessons: lessons,
        startTime: startTime,
        endTime: endTime,
        user: profile
      ));
    } catch (e) {
      emit(state.copyWith(status: ClassLessonStateStatus.failure));
    }
  }

  void updateDateRange(DateTime startTime, DateTime endTime) {
    emit(state.copyWith(startTime: startTime, endTime: endTime));
    reload();
  }

  void reload() async {
    emit(state.copyWith(status: ClassLessonStateStatus.loading));
    try {
      final lessons = await _classRepository.getLessonsInRange(state.classId, state.startTime, state.endTime);
      emit(state.copyWith(
        status: ClassLessonStateStatus.success,
        lessons: lessons,
      ));
    } catch (e) {
      emit(state.copyWith(status: ClassLessonStateStatus.failure));
    }
  }
}
