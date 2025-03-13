import 'package:e_tutor/app/app.dart';
import 'package:e_tutor/layout/layout.dart';
import 'package:e_tutor/login/login.dart';
import 'package:flutter/widgets.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [LayoutPage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}