import 'package:authentication_repository/authentication_repository.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:profile_repository/profile_repository.dart';

part 'profile_update_state.dart';

class ProfileUpdateCubit extends Cubit<ProfileUpdateState> {

  final ProfileRepository _profileRepository;
  final AuthenticationRepository _authenticationRepository;

  ProfileUpdateCubit(this._profileRepository, this._authenticationRepository) : super(const ProfileUpdateState());

  void initialize() async {
    final user = await _authenticationRepository.user.first;
    final profile = await _profileRepository.getProfile(user.id);
    emit(state.copyWith(
      name: profile.name,
      birthDate: profile.birthDate,
      address: profile.address,
      phoneNumber: profile.phoneNumber,
    ));
  }

  void nameChanged(String value) {
    emit(state.copyWith(
      name: value,
    ));
  }

  void birthDateChanged(DateTime value) {
    emit(state.copyWith(
      birthDate: value,
    ));
  }

  void addressChanged(String value) {
    emit(state.copyWith(
      address: value,
    ));
  }

  void phoneNumberChanged(String value) {
    emit(state.copyWith(
      phoneNumber: value,
    ));
  }

  void submit() async {
    try {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      final user = await _authenticationRepository.user.first;
      final newProfile = Profile(
        id: user.id,
        name: state.name,
        birthDate: state.birthDate,
        address: state.address,
        phoneNumber: state.phoneNumber,
      );
      _profileRepository.updateProfile(newProfile);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
