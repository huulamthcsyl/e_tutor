import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/class_detail/class_detail.dart';
import 'package:e_tutor/class_detail/view/class_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassDetailPage extends StatelessWidget {
  const ClassDetailPage({super.key});

  static Route<void> route({String? id}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => ClassDetailCubit(
          context.read<ClassRepository>(),
        )..fetchClassDetail(id ?? ''),
        child: const ClassDetailPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin lớp học',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const ClassDetailView(),
    );
  }
}
