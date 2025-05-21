import 'package:authentication_repository/authentication_repository.dart';
import 'package:e_tutor/payment_list/payment_list.dart';
import 'package:e_tutor/profile/cubit/profile_cubit.dart';
import 'package:e_tutor/profile_update/view/profile_update_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        switch (state.status) {
          case ProfileStatus.failure:
            return const Text('Failed to fetch profile');
          case ProfileStatus.success:
            return Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: state.profile.avatarUrl != null
                        ? NetworkImage(state.profile.avatarUrl!)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text('Xin chào, ${state.profile.name}',
                      style: const TextStyle(
                        fontSize: 22,
                      )),
                  const SizedBox(height: 16),
                  const _UpdateProfileButton(),
                  const SizedBox(height: 16),
                  const _PaymentListButton(),
                  const Expanded(child: SizedBox()),
                  const _LogoutButton(),
                ],
              ),
            );
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

class _UpdateProfileButton extends StatelessWidget {
  const _UpdateProfileButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => const ProfileUpdatePage(),
        ));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Cập nhật hồ sơ',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentListButton extends StatelessWidget {
  const _PaymentListButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => const PaymentListPage(),
        ));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.payment,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Lịch sử thanh toán',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AuthenticationRepository>().logOut();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            Text(
              'Đăng xuất',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
