import 'package:e_tutor/class/class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassView extends StatelessWidget {
  const ClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassCubit, ClassState>(
      builder: (context, state) {
        switch (state.status) {
          case ClassStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ClassStatus.success:
            return ListView.builder(
              itemCount: state.classes.length,
              itemBuilder: (context, index) {
                final _class = state.classes[index];
                return ListTile(
                  title: Text(_class.name ?? ""),
                  subtitle: Text(_class.description ?? ""),
                );
              },
            );
          default:
            return const Center(child: Text('Failed to fetch classes'));
        }
      },
    );
  }
}
