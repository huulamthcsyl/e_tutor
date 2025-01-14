part of 'profile_update_cubit.dart';

class ProfileUpdateState extends Equatable {

  final String name;
  final DateTime birthDate;
  final String address;
  final String phoneNumber;
  final FormzSubmissionStatus status;

  const ProfileUpdateState({
    this.name = '',
    this.birthDate = const ConstDateTime(2025),
    this.address = '',
    this.phoneNumber = '',
    this.status = FormzSubmissionStatus.initial,
  });

  @override
  List<Object> get props => [name, birthDate, address, phoneNumber, status];

  ProfileUpdateState copyWith({
    String? name,
    DateTime? birthDate,
    String? address,
    String? phoneNumber,
    FormzSubmissionStatus? status,
  }) {
    return ProfileUpdateState(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }
}

