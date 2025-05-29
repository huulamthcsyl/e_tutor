part of 'payment_detail_cubit.dart';

enum PaymentDetailStatus {
  initial,
  loading,
  success,
  failure,
}

class PaymentDetailState extends Equatable {
  final PaymentDetailStatus status;
  final Payment payment;

  const PaymentDetailState({
    this.status = PaymentDetailStatus.initial,
    this.payment = const Payment(
      id: '',
      amount: 0,
      method: '',
      note: '',
      billImages: [],
      createdAt: ConstDateTime(0),
      lessonIds: [],
      parentId: '',
      tutorId: '',
    ),
  });

  @override
  List<Object> get props => [status, payment];

  PaymentDetailState copyWith({
    PaymentDetailStatus? status,
    Payment? payment,
  }) {
    return PaymentDetailState(
      status: status ?? this.status,
      payment: payment ?? this.payment,
    );
  }
}

