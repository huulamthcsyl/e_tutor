import 'package:class_repository/class_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:e_tutor/payment/class_tuition/class_tuition.dart';

class ClassTuitionPage extends StatelessWidget {
  const ClassTuitionPage({super.key});

  static Route<void> route({required String classId}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => ClassTuitionCubit(
          context.read<ClassRepository>(),
        )..initialize(classId),
        child: const ClassTuitionPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thanh toán học phí',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const ClassTuitionView(),
    );
  }
}
