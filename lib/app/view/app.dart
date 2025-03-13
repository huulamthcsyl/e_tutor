import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/app/app.dart';
import 'package:e_tutor/theme.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

class App extends StatelessWidget {
  const App(
    {
      required AuthenticationRepository authenticationRepository, 
      required ClassRepository classRepository,
      required ProfileRepository profileRepository,
      super.key
    })
    : _authenticationRepository = authenticationRepository, _classRepository = classRepository, _profileRepository = profileRepository;

  final AuthenticationRepository _authenticationRepository;
  final ClassRepository _classRepository;
  final ProfileRepository _profileRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _classRepository),
        RepositoryProvider.value(value: _profileRepository)
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
