import 'package:authentication_repository/authentication_repository.dart';
import 'package:e_tutor/app/app.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App(
      {required AuthenticationRepository authenticationRepository, super.key})
      : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        lazy: false,
        create: (context) => AppBloc(
          _authenticationRepository
        )..add(const AppUserSubscriptionRequested()),
        child: const AppView(),
      ),
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
      home: FlowBuilder(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages
      )
    );
  }
}
