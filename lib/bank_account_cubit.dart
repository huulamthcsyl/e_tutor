import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bank_account_state.dart';

class BankAccountCubit extends Cubit<BankAccountState> {
  BankAccountCubit() : super(BankAccountInitial());
}
