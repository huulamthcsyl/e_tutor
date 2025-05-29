import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart' as class_repo;
import 'package:e_tutor/homework/create_homework/view/create_homework_page.dart';
import 'package:e_tutor/homework/homework_detail/cubit/homework_detail_cubit.dart';
import 'package:e_tutor/homework/homework_detail/view/homework_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

class HomeworkPage extends StatelessWidget {
  const HomeworkPage({super.key});

  static Route route({required String id}) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => HomeworkCubit(
          RepositoryProvider.of<class_repo.ClassRepository>(context),
          RepositoryProvider.of<ProfileRepository>(context),
          RepositoryProvider.of<AuthenticationRepository>(context),
        )..initialize(id),
        child: const HomeworkPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeworkCubit, HomeworkState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.homework.title,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: state.user.role == "tutor" ? [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    CreateHomeworkPage.route(
                      classId: state.homework.classId,
                      lessonId: state.homework.lessonId,
                      homework: state.homework,
                    ),
                  ).then((value) {
                    context.read<HomeworkCubit>().initialize(state.homework.id!);
                  });
                },
              ),
            ] : [],
          ),
          body: state.status == HomeworkStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : HomeworkView(homework: state.homework, user: state.user, studentWorks: state.studentWorks),
        );
      },
    );
  }
}
