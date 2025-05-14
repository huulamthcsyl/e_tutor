import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/app/app.dart';
import 'package:e_tutor/theme.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:payment_repository/payment_repository.dart';
import 'package:profile_repository/profile_repository.dart';

class App extends StatelessWidget {
  const App(
    {
      required AuthenticationRepository authenticationRepository, 
      required ClassRepository classRepository,
      required ProfileRepository profileRepository,
      required NotificationRepository notificationRepository,
      required PaymentRepository paymentRepository,
      super.key
    })
    : _authenticationRepository = authenticationRepository, _classRepository = classRepository, _profileRepository = profileRepository, _notificationRepository = notificationRepository, _paymentRepository = paymentRepository;

  final AuthenticationRepository _authenticationRepository;
  final ClassRepository _classRepository;
  final ProfileRepository _profileRepository;
  final NotificationRepository _notificationRepository;
  final PaymentRepository _paymentRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _classRepository),
        RepositoryProvider.value(value: _profileRepository),
        RepositoryProvider.value(value: _notificationRepository),
        RepositoryProvider.value(value: _paymentRepository),
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          _authenticationRepository,
        )..add(const AppUserSubscriptionRequested()),
        child: const AppView()
      )
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Tutor',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: FlowBuilder(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages
      )
    );
  }
}
