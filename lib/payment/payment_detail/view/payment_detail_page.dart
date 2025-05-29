import 'package:e_tutor/payment/payment_detail/payment_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_repository/payment_repository.dart';

class PaymentDetailPage extends StatelessWidget {
  const PaymentDetailPage({super.key});

  static Route<void> route({String? id}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => PaymentDetailCubit(
          context.read<PaymentRepository>(),
        )..fetchPaymentDetail(id ?? ''),
        child: const PaymentDetailPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết thanh toán'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<PaymentDetailCubit, PaymentDetailState>(
        builder: (context, state) {
          return const PaymentDetailView();
        },
      ),
    );
  }
}