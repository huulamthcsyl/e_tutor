import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

part 'profile_page_state.dart';

class ProfileCubit extends Cubit<ProfileState> {

  final AuthenticationRepository _authenticationRepository;
  final ProfileRepository _profileRepository;

  ProfileCubit(this._authenticationRepository, this._profileRepository) : super(const ProfileState());
  
  Future<void> fetchProfile() async {
    final user = await _authenticationRepository.user.first;
    try {
      final profile = await _profileRepository.getProfile(user.id);
      emit(state.copyWith(
        profile: profile,
        status: ProfileStatus.success,
      ));
    } on Exception {
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }
}
