import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../class_exam.dart';
import 'package:class_repository/class_repository.dart';

class ClassExamPage extends StatelessWidget {
  const ClassExamPage({super.key});

  static Route<void> route({required String classId}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => ClassExamCubit(
          context.read<ClassRepository>(),
        )..initialize(classId),
        child: const ClassExamPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ClassExamView();
  }
}
