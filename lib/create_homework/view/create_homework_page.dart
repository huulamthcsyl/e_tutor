import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/create_homework/cubit/create_homework_cubit.dart';
import 'package:e_tutor/create_homework/view/create_homework_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateHomeworkPage extends StatelessWidget {
  const CreateHomeworkPage({super.key});

  static Route<void> route({String? classId, String? lessonId, Homework? homework}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => CreateHomeworkCubit(
          context.read<ClassRepository>(),
        )..initialize(classId, lessonId, homework),
        child: const CreateHomeworkPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tạo bài tập về nhà',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const CreateHomeworkForm(),
    );
  }
}