import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:e_tutor/utils/format_currency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_tutor/payment/cubit/payment_cubit.dart';
import 'package:formz/formz.dart';
import 'package:payment_repository/payment_repository.dart';
import 'package:e_tutor/class_detail/view/class_detail_page.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state.formzStatus == FormzSubmissionStatus.success) {
          Navigator.of(context).pushReplacement(ClassDetailPage.route(id: state.classId));
        }
      },
      child: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Thanh toán'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total amount display
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tổng tiền:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          FormatCurrency.format(state.amount),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Payment options
                  const Text(
                    'Chọn phương thức thanh toán:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Cash payment option
                  _PaymentOptionCard(
                    title: 'Thanh toán tiền mặt',
                    description: 'Thanh toán trực tiếp với gia sư',
                    icon: Icons.money,
                    isSelected:
                        state.selectedPaymentMethod == PaymentMethod.cash,
                    onTap: () {
                      context.read<PaymentCubit>().selectPaymentMethod(
                            PaymentMethod.cash,
                          );
                    },
                  ),
                  const SizedBox(height: 16),
                  // QR code payment option
                  _PaymentOptionCard(
                    title: 'Thanh toán qua QR Code',
                    description: 'Quét mã QR để thanh toán',
                    icon: Icons.qr_code,
                    isSelected:
                        state.selectedPaymentMethod == PaymentMethod.bank,
                    onTap: () {
                      context
                          .read<PaymentCubit>()
                          .selectPaymentMethod(PaymentMethod.bank);
                    },
                  ),
                  if (state.selectedPaymentMethod == PaymentMethod.bank) ...[
                    const SizedBox(height: 16),
                    state.tutorBankAccount.accountNumber != null
                        ? Center(
                            child: Column(
                              children: [
                                Image.network(
                                    'https://qr.sepay.vn/img?acc=${state.tutorBankAccount.accountNumber}&bank=${state.tutorBankAccount.bankName}&amount=${state.amount}&des=',
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: 200,
                                    errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Text(
                                      'Không thể tải mã QR',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 8),
                                const Text(
                                  'Quét mã QR để thanh toán',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Text('Không có tài khoản ngân hàng'),
                  ],
                  const SizedBox(height: 24),
                  // Note field
                  const Text(
                    'Ghi chú:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: (value) {
                      context.read<PaymentCubit>().updateNote(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Nhập ghi chú (nếu có)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Bill image upload
                  const Text(
                    'Hóa đơn:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  state.billImage.isNotEmpty
                      ? Row(
                          children: [
                            for (final image in state.billImage)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Image.network(
                                  image,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(height: 8),
                  DottedBorder(
                    color: Colors.blue,
                    strokeWidth: 2,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(8),
                    child: InkWell(
                      onTap: () {
                        context.read<PaymentCubit>().pickBillImage();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Tải lên hóa đơn',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...[
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<PaymentCubit>().submitPayment();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: state.status == PaymentStatus.loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Xác nhận thanh toán',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: isSelected ? Colors.blue.shade50 : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.blue : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
