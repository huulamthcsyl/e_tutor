import 'package:e_tutor/payment_list/payment_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_repository/payment_repository.dart';

class PaymentListPage extends StatelessWidget {
  
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (context) => const PaymentListPage());
  }

  const PaymentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách thanh toán'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => PaymentListCubit(
          context.read<PaymentRepository>(),
        )..initialize(),
        child: const PaymentListView(),
      ),
    );
  }
}