import 'package:e_tutor/utils/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_repository/payment_repository.dart';
import 'package:profile_repository/profile_repository.dart';

part 'payment_list_state.dart';

class PaymentListCubit extends Cubit<PaymentListState> {

final PaymentRepository paymentRepository;

  PaymentListCubit(this.paymentRepository) : super(const PaymentListState());

  Future<void> initialize() async {
    final user = await AuthService().getCurrentUserProfile();
    emit(state.copyWith(user: user));
    await fetchPayments();
  }

  Future<void> fetchPayments() async {
    emit(state.copyWith(status: PaymentListStatus.loading));
    final payments = await paymentRepository.getPayments(state.user.id);
    emit(state.copyWith(status: PaymentListStatus.success, payments: payments));
  }
}
