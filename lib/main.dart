import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/app/view/app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'package:profile_repository/profile_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authenticationRepository = AuthenticationRepository();
  final classRepository = ClassRepository();
  final profileRepository = ProfileRepository();
  await authenticationRepository.user.first;

  initializeDateFormatting().then((_) => runApp(App(
    authenticationRepository: authenticationRepository,
    classRepository: classRepository,
    profileRepository: profileRepository,
  )));
}