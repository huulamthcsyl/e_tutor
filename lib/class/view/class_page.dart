import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/class/class.dart';
import 'package:e_tutor/class/view/class_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

class ClassPage extends StatelessWidget {
  const ClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClassCubit(
        context.read<ClassRepository>(),
        context.read<AuthenticationRepository>(),
        context.read<ProfileRepository>(),
      )..getClasses(),
      child: const ClassView(),
    );
  }
}