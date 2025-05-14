part of 'bank_account_cubit.dart';

sealed class BankAccountState extends Equatable {
  const BankAccountState();
}

final class BankAccountInitial extends BankAccountState {
  @override
  List<Object> get props => [];
}
