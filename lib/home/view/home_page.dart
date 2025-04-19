import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/home/home.dart';
import 'package:e_tutor/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_repository/notification_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
        context.read<ClassRepository>(),
        context.read<AuthenticationRepository>(),
        context.read<NotificationRepository>(),
      )..initialize(),
      child: const HomeView(),
    );
  }
}
