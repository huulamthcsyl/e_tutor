import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/home/home.dart';
import 'package:e_tutor/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'eTutor',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: BlocProvider(
        create: (_) => HomeCubit(
          context.read<ClassRepository>(),
          context.read<AuthenticationRepository>(),
        )..initialize(),
        child: const HomeView(),
      )
    );
  }
}
