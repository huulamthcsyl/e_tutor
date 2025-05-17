import 'package:e_tutor/payment/view/payment_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_repository/payment_repository.dart';
import 'package:profile_repository/profile_repository.dart';

import '../cubit/payment_cubit.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  static Route<void> route({required String classId, required int amount, required Set<String> lessons, required String tutorId}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => PaymentCubit(
          RepositoryProvider.of<PaymentRepository>(context),
          RepositoryProvider.of<ProfileRepository>(context),
        )..initialize(classId, amount, lessons, tutorId),
        child: const PaymentPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const PaymentView();
  }
}
