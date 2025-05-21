import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/lesson/lesson.dart';
import 'package:e_tutor/lesson/view/lesson_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

  static Route<String> route({String? classId, String? lessonId}) {
    return MaterialPageRoute<String>(
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
    return BlocListener<LessonCubit, LessonState>(
      listener: (context, state) {
        if (state.isCancelled) {
          Navigator.of(context).pop("cancelled");
        }
      },
      child: BlocBuilder<LessonCubit, LessonState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Thông tin buổi học'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              iconTheme: const IconThemeData(color: Colors.white),
              foregroundColor: Colors.white,
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'cancel_lesson',
                      child: Text('Hủy buổi học'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'cancel_lesson') {
                      context.read<LessonCubit>().cancelLesson();
                    }
                  },
                ),
              ],
            ),
            body: const LessonView(),
          );
        },
      ),
    );
  }
}
