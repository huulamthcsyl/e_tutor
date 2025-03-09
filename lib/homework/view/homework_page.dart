import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/homework/cubit/homework_cubit.dart';
import 'package:e_tutor/homework/view/homework_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeworkPage extends StatelessWidget {
  const HomeworkPage({super.key});

  static Route route({required String id}) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => HomeworkCubit(
          RepositoryProvider.of<ClassRepository>(context),
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
          ),
          body: state.status == HomeworkStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : HomeworkView(homework: state.homework),
        );
      },
    );
  }
}
