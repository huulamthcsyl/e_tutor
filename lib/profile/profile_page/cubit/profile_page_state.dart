part of 'profile_page_cubit.dart';

enum ProfileStatus { initial, success, failure }

class ProfileState extends Equatable {

  final Profile profile;
  final ProfileStatus status;

  const ProfileState({
    this.profile = const Profile(id: ''),
    this.status = ProfileStatus.initial,
  });

  @override
  List<Object> get props => [profile, status];

  ProfileState copyWith({
    Profile? profile,
    ProfileStatus? status,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      status: status ?? this.status,
    );
  }
}

