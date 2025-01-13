import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String? name;
  final DateTime? birthDate;
  final String? address;
  final String? phoneNumber;
  final String? avatarUrl;

  const Profile({
    required this.id,
    this.name,
    this.birthDate,
    this.address,
    this.phoneNumber,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, birthDate, address, phoneNumber, avatarUrl];
}