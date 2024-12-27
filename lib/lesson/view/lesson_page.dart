import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/lesson/lesson.dart';
import 'package:e_tutor/lesson/view/lesson_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

  static Route<void> route({String? id}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => LessonCubit(
          classRepository: RepositoryProvider.of<ClassRepository>(context),
        )..getClassInfo(id ?? ''),
        child: const LessonPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin buổi học',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const LessonView(),
    );
  }
}