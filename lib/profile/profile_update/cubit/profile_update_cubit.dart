import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
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
    final String bankJson = await rootBundle.loadString('assets/bank.json');
    final List<dynamic> bankInfos = jsonDecode(bankJson);
    emit(state.copyWith(
      name: profile.name,
      address: profile.address,
      phoneNumber: profile.phoneNumber,
      birthDate: profile.birthDate,
      bankInfos: bankInfos.map((e) => BankInfo.fromJson(e)).toList(),
      avatarUrl: profile.avatarUrl,
      role: profile.role,
      bankAccount: profile.bankAccount,
    ));
  }

  Future<void> pickAvatar() async {
    try {
      final FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (file != null) {
        final fileBytes = file.files.first.bytes;
        if (fileBytes != null) {
          final user = await _authenticationRepository.user.first;
          await _profileRepository.uploadProfileImage(
            user.id,
            file.files.first.name,
            fileBytes,
          );
          final profile = await _profileRepository.getProfile(user.id);
          emit(state.copyWith(avatarUrl: profile.avatarUrl));
        }
      }
    } catch (e) {
      // Handle error
    }
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

  void bankChanged(String value) {
    emit(state.copyWith(
      bankAccount: state.bankAccount.copyWith(bankName: value),
    ));
  }

  void bankNumberChanged(String value) {
    emit(state.copyWith(
      bankAccount: state.bankAccount.copyWith(accountNumber: value),
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
        bankAccount: state.bankAccount,
        avatarUrl: state.avatarUrl,
      );
      _profileRepository.updateProfile(newProfile);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
