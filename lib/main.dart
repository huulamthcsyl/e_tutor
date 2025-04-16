import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/app/view/app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:notification_repository/notification_repository.dart';
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
  final notificationRepository = NotificationRepository();
  final user = await authenticationRepository.user.first;

  // Add FCM settings
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  initializeDateFormatting().then((_) => runApp(App(
    authenticationRepository: authenticationRepository,
    classRepository: classRepository,
    profileRepository: profileRepository,
    notificationRepository: notificationRepository,
  )));
}