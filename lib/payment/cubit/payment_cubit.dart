import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:payment_repository/payment_repository.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:random_string/random_string.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {

  final PaymentRepository _paymentRepository;
  final ProfileRepository _profileRepository;

  PaymentCubit(this._paymentRepository, this._profileRepository) : super(const PaymentState());

  Future<void> initialize(String classId, int amount, Set<String> lessons, String tutorId) async {
    final tutor = await _profileRepository.getProfile(tutorId);
    emit(state.copyWith(
      classId: classId,
      paymentId: randomAlphaNumeric(20),
      selectedPaymentMethod: PaymentMethod.cash,
      note: '',
      amount: amount,
      billImage: [],
      errorMessage: null,
      lessonIds: lessons,
      tutorId: tutorId,
      tutorBankAccount: tutor.bankAccount,
    ));
  }

  void selectPaymentMethod(PaymentMethod method) async {
    emit(state.copyWith(
      selectedPaymentMethod: method,
      errorMessage: null,
    ));
  }

  void updateNote(String note) {
    emit(state.copyWith(note: note));
  }

  Future<void> pickBillImage() async {
    try {
      final FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (file != null) {
        final fileBytes = file.files.first.bytes;
        if (fileBytes != null) {
          final imagePath = await _paymentRepository.uploadBillImage(
            state.paymentId,
            file.files.first.name,
            fileBytes,
          );
          emit(state.copyWith(
            billImage: [...state.billImage, imagePath],
            errorMessage: null,
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Không thể tải lên ảnh. Vui lòng thử lại.',
      ));
    }
  }

  void clearBillImage() {
    emit(state.copyWith(billImage: null));
  }

  Future<void> submitPayment() async {
    emit(state.copyWith(formzStatus: FormzSubmissionStatus.inProgress));
    try {
      final payment = Payment( 
        id: state.paymentId,
        amount: state.amount,
        method: state.selectedPaymentMethod.name,
        note: state.note,
        billImages: state.billImage,
        createdAt: DateTime.now(),
        lessonIds: state.lessonIds.toList(),
      );
      await _paymentRepository.createPayment(payment);
      emit(state.copyWith(formzStatus: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(formzStatus: FormzSubmissionStatus.failure));
    }
  }

  void reset() {
    emit(const PaymentState());
  }
}
