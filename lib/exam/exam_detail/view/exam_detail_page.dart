import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/exam/exam_detail/exam_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamPage extends StatelessWidget {
  const ExamPage({super.key});

  static Route<String> route({required String examId}) {
    return MaterialPageRoute<String>(
      builder: (context) => BlocProvider(
        create: (context) => ExamCubit(
          context.read<ClassRepository>(),
        )..initialize(examId),
        child: const ExamPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ExamView();
  }
}
