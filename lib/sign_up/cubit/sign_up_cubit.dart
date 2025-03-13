import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:profile_repository/profile_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository, this._profileRepository) : super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;
  final ProfileRepository _profileRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([email, state.password, state.confirmedPassword]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(state.copyWith(
      password: password,
      confirmedPassword: confirmedPassword,
      isValid: Formz.validate([state.email, password, confirmedPassword]),
    ));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
      isValid: Formz.validate([state.email, state.password, confirmedPassword]),
    ));
  }

  void fullNameChanged(String value) {
    final fullName = RequiredText.dirty(value);
    emit(state.copyWith(
      fullName: fullName,
      isValid: Formz.validate([state.email, state.password, state.confirmedPassword, fullName]),
    ));
  }

  void roleChanged(String role) {
    emit(state.copyWith(
      role: role,
      isValid: Formz.validate([state.email, state.password, state.confirmedPassword, state.fullName]),
    ));
  }

  Future<void> signUpWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final uid = await _authenticationRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      final profile = Profile(
        id: uid,
        name: state.fullName.value,
        role: state.role,
      );
      await _profileRepository.createProfile(profile);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.message,
      ));
    } on Exception {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
