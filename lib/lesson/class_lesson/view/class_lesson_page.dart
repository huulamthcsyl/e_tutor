import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

import '../cubit/class_lesson_cubit.dart';
import 'class_lesson_view.dart';

class ClassLessonPage extends StatelessWidget {
  const ClassLessonPage({super.key});

  static Route<void> route({String? id}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => ClassLessonCubit(
          context.read<ClassRepository>(),
          context.read<AuthenticationRepository>(),
          context.read<ProfileRepository>(),
        )..initialize(id ?? ''),
        child: const ClassLessonPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ClassLessonView();
  }
}
