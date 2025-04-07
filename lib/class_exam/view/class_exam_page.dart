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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh sách bài kiểm tra',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const ClassExamView(),
    );
  }
}
