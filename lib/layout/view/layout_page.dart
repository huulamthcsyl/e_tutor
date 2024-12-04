import 'package:e_tutor/layout/layout.dart';
import 'package:e_tutor/layout/view/layout_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LayoutPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => LayoutBloc()..add(const TabChanged(0)),
      child: const LayoutView(),
    );
  }
}
