import 'package:e_tutor/utils/auth_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:payment_repository/payment_repository.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:random_string/random_string.dart';

part 'payment_transaction_state.dart';

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
        emit(state.copyWith(loadingStatus: LoadingStatus.loading));
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
      emit(state.copyWith(loadingStatus: LoadingStatus.success));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Không thể tải lên ảnh. Vui lòng thử lại.',
      ));
      emit(state.copyWith(loadingStatus: LoadingStatus.failure));
    }
  }

  void clearBillImage() {
    emit(state.copyWith(billImage: null));
  }

  void removeBillImage(String imageUrl) {
    final updatedImages = List<String>.from(state.billImage)
      ..remove(imageUrl);
    emit(state.copyWith(billImage: updatedImages));
  }

  Future<void> submitPayment() async {
    emit(state.copyWith(formzStatus: FormzSubmissionStatus.inProgress));
    try {
      final parent = await AuthService().getCurrentUserProfile();
      final payment = Payment( 
        id: state.paymentId,
        amount: state.amount,
        method: state.selectedPaymentMethod.name,
        note: state.note,
        billImages: state.billImage,
        createdAt: DateTime.now(),
        lessonIds: state.lessonIds.toList(),
        tutorId: state.tutorId,
        parentId: parent.id,
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
