part of 'payment_list_cubit.dart';

enum PaymentListStatus { initial, loading, success, failure }

class PaymentListState extends Equatable {
  final PaymentListStatus status;
  final List<Payment> payments;
  final String errorMessage;
  final Profile user;

  const PaymentListState({
    this.status = PaymentListStatus.initial,
    this.payments = const [],
    this.errorMessage = '',
    this.user = const Profile(
      id: '',
    ),
  });

  @override
  List<Object> get props => [status, payments, errorMessage, user];

  PaymentListState copyWith({
    PaymentListStatus? status,
    List<Payment>? payments,  
    String? errorMessage,
    Profile? user,
  }) {
    return PaymentListState( 
      status: status ?? this.status, 
      payments: payments ?? this.payments, 
      errorMessage: errorMessage ?? this.errorMessage, 
      user: user ?? this.user
    );
  }
}
