import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/class/class_detail/class_detail.dart';
import 'package:e_tutor/class/class_detail/view/class_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

class ClassDetailPage extends StatelessWidget {
  const ClassDetailPage({super.key});

  static Route<void> route({String? id}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => ClassDetailCubit(
          context.read<ClassRepository>(),
          context.read<ProfileRepository>(),
          context.read<AuthenticationRepository>(),
        )..fetchClassDetail(id ?? ''),
        child: const ClassDetailPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ClassDetailView();
  }
}
