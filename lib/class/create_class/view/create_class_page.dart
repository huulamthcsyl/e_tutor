import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/class/create_class/create_class.dart';
import 'package:e_tutor/class/create_class/view/create_class_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

class CreateClassPage extends StatelessWidget {
  const CreateClassPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const CreateClassPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tạo lớp học',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) => CreateClassCubit(
            context.read<ClassRepository>(),
            context.read<AuthenticationRepository>(),
            context.read<ProfileRepository>(),
          )..initialize(),
          child: const CreateClassForm(),
        ),
      ),
    );
  }
}
