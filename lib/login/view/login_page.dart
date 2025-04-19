import 'package:authentication_repository/authentication_repository.dart';
import 'package:e_tutor/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_repository/notification_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) => LoginCubit(
            context.read<AuthenticationRepository>(),
            context.read<NotificationRepository>(),
          ),
          child: const LoginForm(),
        ),
      ),
    );
  }
}
