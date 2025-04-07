import 'package:e_tutor/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/class_exam_cubit.dart';

class ClassExamView extends StatelessWidget {
  const ClassExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassExamCubit, ClassExamState>(
      builder: (context, state) {
        switch (state.status) {
          case ClassExamStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ClassExamStatus.loaded:
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Thời gian:'),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: state.startTime,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          ).then((date) {
                            if (date != null) {
                              context.read<ClassExamCubit>().startTimeChanged(date);
                            }
                          });
                        },
                        child: Text(
                          FormatTime.formatDate(state.startTime),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      const Text(' - '),
                      GestureDetector(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: state.endTime,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          ).then((date) {
                            if (date != null) {
                              context.read<ClassExamCubit>().endTimeChanged(date);
                            }
                          });
                        },
                        child: Text(
                          FormatTime.formatDate(state.endTime),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.exams.length,
                      itemBuilder: (context, index) {
                        final exam = state.exams[index];
                        return ListTile(
                          title: Text(exam.title ?? ""),
                          subtitle: Text('Thời gian bắt đầu: ${exam.startTime}'),
                          onTap: () {
                            // Handle exam tap
                          },
                        );
                      },
                    ),
                  ),
                ],
              )
            );
          case ClassExamStatus.error:
            return const Center(child: Text('Không thể tải danh sách bài kiểm tra'));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
