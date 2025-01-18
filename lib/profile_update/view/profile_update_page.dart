import 'package:authentication_repository/authentication_repository.dart';
import 'package:e_tutor/profile_update/cubit/profile_update_cubit.dart';
import 'package:e_tutor/profile_update/view/profile_update_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

class ProfileUpdatePage extends StatelessWidget {
  const ProfileUpdatePage({super.key});

  static Route<void> route() => MaterialPageRoute<void>(builder: (_) => const ProfileUpdatePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cập nhật thông tin',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<ProfileUpdateCubit>(
          create: (context) => ProfileUpdateCubit(
            context.read<ProfileRepository>(),
            context.read<AuthenticationRepository>(),
          )..initialize(),
          child: const ProfileUpdateForm(),
        )
      ),
    );
  }
}