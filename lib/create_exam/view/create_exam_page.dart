import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/create_exam/create_exam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateExamPage extends StatelessWidget {
  const CreateExamPage({super.key});

  static Route<String> route({required String classId}) {
    return MaterialPageRoute<String>(
      builder: (context) => BlocProvider(
        create: (context) => CreateExamCubit(
          context.read<ClassRepository>(),
        )..initialize(classId),
        child: const CreateExamPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tạo bài kiểm tra',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const CreateExamView()
    );
  }
}
