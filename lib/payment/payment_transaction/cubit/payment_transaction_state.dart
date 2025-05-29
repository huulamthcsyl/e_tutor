part of 'payment_transaction_cubit.dart';

enum PaymentStatus { initial, loading, success, failure }

enum LoadingStatus { initial, loading, success, failure }
class PaymentState extends Equatable {
  final String classId;
  final PaymentStatus status;
  final PaymentMethod selectedPaymentMethod;
  final String note;
  final int amount;
  final List<String> billImage;
  final String errorMessage;
  final Set<String> lessonIds;
  final BankAccount tutorBankAccount;
  final String tutorId;
  final FormzSubmissionStatus formzStatus;
  final String paymentId;
  final LoadingStatus loadingStatus;

  const PaymentState({
    this.classId = '',
    this.status = PaymentStatus.initial,
    this.amount = 0,
    this.selectedPaymentMethod = PaymentMethod.cash,
    this.note = '',
    this.billImage = const [],
    this.errorMessage = '',
    this.lessonIds = const {},
    this.tutorBankAccount = const BankAccount(id: '', accountNumber: '', bankName: ''),
    this.tutorId = '',
    this.formzStatus = FormzSubmissionStatus.initial,
    this.paymentId = '',
    this.loadingStatus = LoadingStatus.initial,
  });

  @override
  List<Object> get props => [classId, status, amount, selectedPaymentMethod, note, billImage, errorMessage, lessonIds, tutorBankAccount, tutorId, formzStatus, paymentId, loadingStatus];

  PaymentState copyWith({
    String? classId,
    PaymentStatus? status,
    int? amount,
    PaymentMethod? selectedPaymentMethod,
    String? note,
    List<String>? billImage,
    String? errorMessage,
    Set<String>? lessonIds,
    BankAccount? tutorBankAccount,
    String? tutorId,
    FormzSubmissionStatus? formzStatus,
    String? paymentId,
    LoadingStatus? loadingStatus,
  }) {
    return PaymentState(
      classId: classId ?? this.classId,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      note: note ?? this.note,
      billImage: billImage ?? this.billImage,
      errorMessage: errorMessage ?? this.errorMessage,
      lessonIds: lessonIds ?? this.lessonIds,
      tutorBankAccount: tutorBankAccount ?? this.tutorBankAccount,
      tutorId: tutorId ?? this.tutorId,
      formzStatus: formzStatus ?? this.formzStatus,
      paymentId: paymentId ?? this.paymentId,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }
}
