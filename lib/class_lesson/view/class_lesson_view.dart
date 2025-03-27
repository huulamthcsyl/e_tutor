import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../lesson/view/lesson_page.dart';
import '../cubit/class_lesson_cubit.dart';

class ClassLessonView extends StatelessWidget {
  const ClassLessonView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassLessonCubit, ClassLessonState>(
      builder: (context, state) {
        switch (state.status) {
          case ClassLessonStateStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ClassLessonStateStatus.success:
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Thời gian: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          final result = await showDatePicker(
                            context: context,
                            initialDate: state.startTime,
                            firstDate: DateTime(2025),
                            lastDate: DateTime(2100),
                          );
                          if (result != null) {
                            context.read<ClassLessonCubit>().updateDateRange(result, state.endTime);
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          child: Text(
                            FormatTime.formatDate(state.startTime)
                          ),
                        ),
                      ),
                      const Text(' - '),
                      GestureDetector(
                        onTap: () async {
                          final result = await showDatePicker(
                            context: context,
                            initialDate: state.endTime,
                            firstDate: DateTime(2025),
                            lastDate: DateTime(2100),
                          );
                          if (result != null) {
                            context.read<ClassLessonCubit>().updateDateRange(state.startTime, result);
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          child: Text(
                            FormatTime.formatDate(state.endTime)
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (final lesson in state.lessons)
                    _LessonTile(lesson: lesson)
                ],
              )
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}

class _LessonTile extends StatelessWidget {
  final Lesson lesson;

  const _LessonTile({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push<void>(
        LessonPage.route(
          classId: lesson.classId,
          lessonId: lesson.id,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.watch_later,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  '${FormatTime.formatTime(lesson.startTime)} - ${FormatTime.formatTime(lesson.endTime)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  FormatTime.formatDate(lesson.startTime),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
