import 'package:class_repository/class_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/class_lesson_cubit.dart';
import 'class_lesson_view.dart';

class ClassLessonPage extends StatelessWidget {
  const ClassLessonPage({super.key});

  static Route<void> route({String? id}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => ClassLessonCubit(
          context.read<ClassRepository>(),
        )..initialize(id ?? ''),
        child: const ClassLessonPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buổi học',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const ClassLessonView(),
    );
  }
}
