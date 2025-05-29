import 'package:class_repository/class_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/grade_homework_cubit.dart';

class GradeHomeworkDialog extends StatelessWidget {

  final Homework homework;
  const GradeHomeworkDialog({super.key, required this.homework});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GradeHomeworkCubit(
        context.read<ClassRepository>(),
      )..initialize(homework),
      child: BlocBuilder<GradeHomeworkCubit, GradeHomeworkState>(
        builder: (context, state) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Chấm điểm bài tập',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Điểm:'),
                      const SizedBox(width: 16),
                      _GradeInput(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Phản hồi:'),
                      const SizedBox(width: 16),
                      _FeedbackInput(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _CancelButton(),
                      _GradeButton(),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GradeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GradeHomeworkCubit, GradeHomeworkState>(
      buildWhen: (previous, current) => previous.score != current.score,
      builder: (context, state) {
        return SizedBox(
          width: 100,
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              context.read<GradeHomeworkCubit>().scoreChanged(double.parse(value));
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        );
      },
    );
  }
}

class _FeedbackInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GradeHomeworkCubit, GradeHomeworkState>(
      buildWhen: (previous, current) => previous.feedback != current.feedback,
      builder: (context, state) {
        return SizedBox(
          width: 300,
          child: TextField(
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 3,
            onChanged: (value) {
              context.read<GradeHomeworkCubit>().feedbackChanged(value);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        );
      },
    );
  }
}

class _CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Hủy'),
    );
  }
}

class _GradeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<GradeHomeworkCubit>().gradeHomework();
        Navigator.of(context).pop();
      },
      child: const Text('Chấm điểm'),
    );
  }
}
