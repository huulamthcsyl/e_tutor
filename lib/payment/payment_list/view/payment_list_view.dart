import 'package:e_tutor/payment/payment_detail/payment_detail.dart';
import 'package:e_tutor/payment/payment_list/payment_list.dart';
import 'package:e_tutor/utils/currency_util.dart';
import 'package:e_tutor/utils/time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_repository/payment_repository.dart';

class PaymentListView extends StatelessWidget {
  const PaymentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentListCubit, PaymentListState>(
      builder: (context, state) {
        switch (state.status) {
          case PaymentListStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case PaymentListStatus.success:
            return Padding(
              padding: const EdgeInsets.all(16), 
              child: Column(
                children: [
                  for (var payment in state.payments)
                    PaymentItem(payment: payment),
                ],
              ),
            );
          case PaymentListStatus.failure:
            return const Center(child: Text('Failed to fetch payments'));
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class PaymentItem extends StatelessWidget {
  final Payment payment;

  const PaymentItem({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push<void>( 
          PaymentDetailPage.route(id: payment.id),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.money, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '${FormatCurrency.format(payment.amount)}đ', 
                  style: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_month, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(FormatTime.formatDateTime(payment.createdAt)),
              ],
            ),
          ],
        ),
      )
    );
  }
}