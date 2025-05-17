import 'package:equatable/equatable.dart';
import 'package:profile_repository/src/models/bank_account.dart';

class Profile extends Equatable {
  final String id;
  final String? name;
  final DateTime? birthDate;
  final String? address;
  final String? phoneNumber;
  final String? avatarUrl;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final BankAccount? bankAccount;

  const Profile({
    required this.id,
    this.name,
    this.birthDate,
    this.address,
    this.phoneNumber,
    this.avatarUrl,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.bankAccount,
  });

  @override
  List<Object?> get props => [id, name, birthDate, address, phoneNumber, avatarUrl, role, createdAt, updatedAt, bankAccount];
}