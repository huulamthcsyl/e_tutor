import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/lesson/lesson.dart';
import 'package:e_tutor/lesson/view/lesson_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

  static Route<void> route({String? classId, String? lessonId}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => LessonCubit(
          RepositoryProvider.of<ClassRepository>(context),
          RepositoryProvider.of<AuthenticationRepository>(context),
          RepositoryProvider.of<ProfileRepository>(context),
        )..initialize(classId!, lessonId!),
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
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const LessonView(),
    );
  }
}