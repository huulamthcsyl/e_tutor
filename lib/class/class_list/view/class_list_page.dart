import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/class/class_list/class_list.dart';
import 'package:e_tutor/class/class_list/view/class_list_view.dart';
import 'package:e_tutor/class/create_class/create_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassPage extends StatelessWidget {
  const ClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClassCubit(
        context.read<ClassRepository>(),
        context.read<AuthenticationRepository>(),
      )..getClasses(),
      child: BlocBuilder<ClassCubit, ClassState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Lớp học',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                state.user.role == "tutor" ? IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).push<void>(
                    CreateClassPage.route(),
                  ),
                ) : const SizedBox(),
              ],
            ),
            body: const ClassView()
          );
        },
      ),
    );
  }
}