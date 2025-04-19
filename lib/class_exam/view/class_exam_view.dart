import 'package:e_tutor/create_exam/view/create_exam_page.dart';
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
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Danh sách bài kiểm tra',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),
                ),
                backgroundColor: Colors.blue,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: const Center(child: CircularProgressIndicator())
            );
          case ClassExamStatus.loaded:
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Danh sách bài kiểm tra',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),
                ),
                backgroundColor: Colors.blue,
                iconTheme: const IconThemeData(color: Colors.white),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).push(
                        CreateExamPage.route(
                          classId: state.classId,
                        )
                      ).then((value) {
                        if (value == 'success') {
                          context.read<ClassExamCubit>().initialize(state.classId);
                        }
                      });
                    },
                  ),
                ],
              ),
              body: Padding(
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
                                context.read<ClassExamCubit>().updateRange(date, state.endTime);
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
                                context.read<ClassExamCubit>().updateRange(state.startTime, date);
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
                    state.exams.isNotEmpty ? Expanded(
                      child: ListView.builder(
                        itemCount: state.exams.length,
                        itemBuilder: (context, index) {
                          final exam = state.exams[index];
                          return ListTile(
                            title: Text(exam.title ?? ""),
                            subtitle: Text('Thời gian bắt đầu: ${FormatTime.formatDateTime(exam.startTime)}'),
                            onTap: () {
                              // Handle exam tap
                            },
                          );
                        },
                      ),
                    ) : (
                      const Center(
                        child: Text('Không có bài kiểm tra nào'),
                      )
                    ),
                  ],
                )
              ),
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
