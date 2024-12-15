import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/create_class/create_class.dart';
import 'package:e_tutor/create_class/view/create_class_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        title: const Text('Tạo lớp học'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) => CreateClassCubit(
            context.read<ClassRepository>(),
          ),
          child: const CreateClassForm(),
        ),
      ),
    );
  }
}