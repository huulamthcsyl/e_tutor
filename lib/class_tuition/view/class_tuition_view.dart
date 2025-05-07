import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/class_tuition/class_tuition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_tutor/utils/format_time.dart';
import 'package:e_tutor/utils/format_currency.dart';

class ClassTuitionView extends StatelessWidget {
  const ClassTuitionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassTuitionCubit, ClassTuitionState>(
      builder: (context, state) {
        switch (state.status) {
          case ClassTuitionStatus.failure:
            return const Center(child: Text('Không thể lấy thông tin học phí'));
          case ClassTuitionStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ClassTuitionStatus.success:
            return Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Class Info
                  if (state.classData != null) ...[
                    Text(
                      state.classData!.name ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Học phí: ${FormatCurrency.format(state.classData!.tuition ?? 0)}/buổi',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Lessons List
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: state.lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = state.lessons[index];
                          return _LessonTile(
                            lesson: lesson,
                            isSelected: state.selectedLessons.contains(lesson.id),
                            onSelect: () {
                              context.read<ClassTuitionCubit>().toggleLessonSelection(lesson.id!);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Bottom section with total, select all and checkout
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        // Select All Row
                        Row(
                          children: [
                            Checkbox(
                              value: state.isAllSelected,
                              onChanged: (_) {
                                context.read<ClassTuitionCubit>().toggleSelectAll();
                              },
                            ),
                            const Text(
                              'Chọn tất cả',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Total and Checkout Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tổng học phí:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  FormatCurrency.format(state.totalTuition),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: state.selectedLessons.isEmpty
                                  ? null
                                  : () {
                                      // TODO: Implement checkout
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Thanh toán',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({
    required this.lesson,
    required this.isSelected,
    required this.onSelect,
  });

  final Lesson lesson;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (_) => onSelect(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
          ],
        ),
      ),
    );
  }
}
