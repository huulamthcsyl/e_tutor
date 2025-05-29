part of 'profile_update_cubit.dart';

class BankInfo {
  final String name;
  final String code;
  final String bin;
  final String? shortName;
  final bool supported;

  const BankInfo({
    required this.name,
    required this.code,
    required this.bin,
    this.shortName,
    required this.supported,
  });

  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
      name: json['name'],
      code: json['code'],
      bin: json['bin'],
      shortName: json['short_name'] ?? '',
      supported: json['supported'], 
    );
  }
}

class ProfileUpdateState extends Equatable {

  final String name;
  final DateTime birthDate;
  final String address;
  final String phoneNumber;
  final FormzSubmissionStatus status;
  final BankAccount bankAccount;
  final List<BankInfo> bankInfos;
  final String? avatarUrl;
  final String role;

  const ProfileUpdateState({
    this.name = '',
    this.birthDate = const ConstDateTime(2025),
    this.address = '',
    this.phoneNumber = '',
    this.status = FormzSubmissionStatus.initial,
    this.bankAccount = const BankAccount(id: '', accountNumber: '', bankName: ''),
    this.bankInfos = const [],
    this.avatarUrl,
    this.role = '',
  });

  @override
  List<Object?> get props => [name, birthDate, address, phoneNumber, status, bankAccount, bankInfos, avatarUrl, role];

  ProfileUpdateState copyWith({
    String? name,
    DateTime? birthDate,
    String? address,
    String? phoneNumber,
    FormzSubmissionStatus? status,
    BankAccount? bankAccount,
    List<BankInfo>? bankInfos,
    String? avatarUrl,
    String? role,
  }) {
    return ProfileUpdateState(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      bankAccount: bankAccount ?? this.bankAccount,
      bankInfos: bankInfos ?? this.bankInfos,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
    );
  }
}

