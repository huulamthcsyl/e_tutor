import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/app/app.dart';
import 'package:e_tutor/theme.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App(
      {required AuthenticationRepository authenticationRepository, required ClassRepository classRepository, super.key})
      : _authenticationRepository = authenticationRepository, _classRepository = classRepository;

  final AuthenticationRepository _authenticationRepository;
  final ClassRepository _classRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _classRepository)
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
