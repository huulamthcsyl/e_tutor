class BankAccount {
  final String? id;
  final String? accountNumber;
  final String? bankName;

  const BankAccount({
    this.id,
    this.accountNumber,
    this.bankName,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'],
      accountNumber: json['accountNumber'],
      bankName: json['bankName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountNumber': accountNumber,
      'bankName': bankName,
    };
  }

  BankAccount copyWith({
    String? id,
    String? accountNumber,
    String? bankName,
  }) {
    return BankAccount(id: id ?? this.id, accountNumber: accountNumber ?? this.accountNumber, bankName: bankName ?? this.bankName);
  }
}

