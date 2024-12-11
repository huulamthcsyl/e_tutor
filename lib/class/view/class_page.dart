import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/class/class.dart';
import 'package:e_tutor/class/view/class_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassPage extends StatelessWidget {
  const ClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lớp học'),
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider(
        create: (_) => ClassCubit(
          context.read<ClassRepository>(),
        )..getClasses(),
        child: const ClassView(),
      ),
    );
  }
}