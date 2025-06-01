import 'package:authentication_repository/authentication_repository.dart';
import 'package:e_tutor/utils/auth_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:profile_repository/profile_repository.dart';

part 'class_list_state.dart';

class ClassCubit extends Cubit<ClassState> {
  final ClassRepository _classRepository;
  final AuthenticationRepository _authenticationRepository;

  ClassCubit(this._classRepository, this._authenticationRepository) : super(const ClassState());

  Future<void> getClasses() async {
    emit(state.copyWith(status: ClassStatus.loading));
    final user = await _authenticationRepository.user.first;
    final profile = await AuthService().getCurrentUserProfile();
    emit(state.copyWith(
      user: profile,
    ));
    _classRepository.getClasses(user.id).listen(
      (classes) {
        emit(state.copyWith(
          status: ClassStatus.success,
          classes: classes,
        ));
      },
      onError: (Object error) {
        emit(state.copyWith(status: ClassStatus.failure));
      },
      onDone: () {
        emit(state.copyWith(status: ClassStatus.success));
      },
    );
  }
}
