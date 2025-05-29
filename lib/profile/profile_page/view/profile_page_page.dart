import 'package:authentication_repository/authentication_repository.dart';
import 'package:e_tutor/profile/profile_page/cubit/profile_page_cubit.dart';
import 'package:e_tutor/profile/profile_page/view/profile_page_view.dart';
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
            'Cá nhân',
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
