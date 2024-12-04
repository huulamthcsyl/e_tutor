import 'package:authentication_repository/authentication_repository.dart';
import 'package:e_tutor/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static Route<void> route() => MaterialPageRoute<void>(builder: (_) => const SignUpPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<SignUpCubit>(
          create: (context) => SignUpCubit(
            context.read<AuthenticationRepository>(),
          ),
          child: const SignUpForm(),
        )
      ),
    );
  }
}