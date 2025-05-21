import 'package:const_date_time/const_date_time.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_repository/payment_repository.dart';

part 'payment_detail_state.dart';

class PaymentDetailCubit extends Cubit<PaymentDetailState> {

  final PaymentRepository paymentRepository;

  PaymentDetailCubit(this.paymentRepository) : super(const PaymentDetailState());

  Future<void> fetchPaymentDetail(String paymentId) async {
    emit(state.copyWith(status: PaymentDetailStatus.loading));
    try {
      final payment = await paymentRepository.getPaymentById(paymentId);
      emit(state.copyWith(status: PaymentDetailStatus.success, payment: payment));
    } catch (e) {
      emit(state.copyWith(status: PaymentDetailStatus.failure));
    }
  }
}
