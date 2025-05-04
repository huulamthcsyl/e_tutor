import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:notification_repository/notification_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;
  final NotificationRepository _notificationRepository;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  LoginCubit(this._authenticationRepository, this._notificationRepository) : super(const LoginState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.email, password]),
    ));
  }

  Future<void> logInWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.logIn(
        email: state.email.value,
        password: state.password.value,
      );
      // Send FCM device token to the server
      final user = await _authenticationRepository.user.first;
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _notificationRepository.sendFCMDeviceToken(user.id, token);
      }
    } on LoginInWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.message,
      ));
    } on Exception {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}