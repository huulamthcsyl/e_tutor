import 'package:authentication_repository/authentication_repository.dart';
import 'package:e_tutor/profile/cubit/profile_cubit.dart';
import 'package:e_tutor/profile/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Hồ sơ',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: SafeArea(
          child: BlocProvider(
            create: (_) => ProfileCubit(
              context.read<AuthenticationRepository>(),
              context.read<ProfileRepository>(),
            )..fetchProfile(),
            child: const ProfileView(),
          ),
        ));
  }
}
