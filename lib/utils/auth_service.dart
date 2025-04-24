import 'package:authentication_repository/authentication_repository.dart';
import 'package:profile_repository/profile_repository.dart';

class AuthService {

  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  final AuthenticationRepository _authenticationRepository = AuthenticationRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<Profile> getCurrentUserProfile() async {
    final user = await _authenticationRepository.user.first;
    return await _profileRepository.getProfile(user.id);
  }
}