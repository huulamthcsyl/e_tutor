import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_repository/notification_repository.dart';

import '../notification.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const NotificationPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông báo',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => NotificationCubit(
          context.read<NotificationRepository>(),
          context.read<AuthenticationRepository>(),
        )..initialize(),
        child: const NotificationView(),
      ),
    );
  }
}
