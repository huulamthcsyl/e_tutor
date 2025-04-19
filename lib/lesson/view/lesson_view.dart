import 'package:class_repository/class_repository.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:e_tutor/create_homework/view/create_homework_page.dart';
import 'package:e_tutor/homework/view/homework_page.dart';
import 'package:e_tutor/lesson/lesson.dart';
import 'package:e_tutor/pdf_view/view/pdf_view_page.dart';
import 'package:e_tutor/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

class LessonView extends StatelessWidget {
  const LessonView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonCubit, LessonState>(
      builder: (context, state) {
        switch (state.status) {
          case LessonStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case LessonStatus.success:
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ClassInfo(
                      classData: state.classData, lesson: state.lessonData),
                  const SizedBox(height: 16),
                  _MaterialInfo(lesson: state.lessonData, user: state.user,),
                  const SizedBox(height: 16),
                  _HomeworkInfo(lesson: state.lessonData, user: state.user,),
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

class _ClassInfo extends StatelessWidget {
  final Class classData;
  final Lesson lesson;

  const _ClassInfo({required this.classData, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thông tin buổi học',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 8),
          RichText(
              text: TextSpan(
            text: 'Tên lớp: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: classData.name ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          )),
          const SizedBox(height: 8),
          RichText(
              text: TextSpan(
            text: 'Thời gian: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text:
                    '${FormatTime.formatTime(lesson.startTime)} - ${FormatTime.formatTime(lesson.endTime)}, ${FormatTime.formatDate(lesson.startTime)}',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class _MaterialInfo extends StatelessWidget {
  final Lesson lesson;
  final Profile user;

  const _MaterialInfo({required this.lesson, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonCubit, LessonState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tài liệu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              ),
              SizedBox(
                width: double.infinity,
                child: (){
                  if (state.lessonData.materials.isEmpty) {
                    return const Text(
                      'Chưa có tài liệu',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final material in state.lessonData.materials)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push<void>(
                            PdfViewPage.route(
                              url: material.url,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                material.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }(),
              ),
              GestureDetector(
                onTap: () {
                  context.read<LessonCubit>().uploadMaterial();
                },
                child: user.role == "tutor" ? DottedBorder(
                  padding: const EdgeInsets.all(8),
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.file_upload,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Upload tài liệu',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  )
                ) : const SizedBox(),
              )
            ],
          ),
        );
      },
    );
  }
}

class _HomeworkInfo extends StatelessWidget {
  final Lesson lesson;
  final Profile user;

  const _HomeworkInfo({required this.lesson, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonCubit, LessonState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Bài tập',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              ),
              SizedBox(
                width: double.infinity,
                child: (){
                  if (state.homeworks.isEmpty) {
                    return const Text(
                      'Chưa có bài tập',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final homework in state.homeworks)
                      _HomeworkCard(homework: homework),
                      const SizedBox(height: 8),
                    ],
                  );
                }(),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push<void>(
                    CreateHomeworkPage.route(
                      classId: lesson.classId,
                      lessonId: lesson.id,
                      className: state.classData.name
                    ),
                  )
                      .then((value) {
                    context.read<LessonCubit>().reloadHomeworks(
                        state.lessonData.classId, state.lessonData.id!);
                  });
                },
                child: user.role == "tutor" ? DottedBorder(
                  padding: const EdgeInsets.all(8),
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add_circle,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tạo bài tập',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  )
                ) : const SizedBox(),
              )
            ],
          ),
        );
      },
    );
  }
}

class _HomeworkCard extends StatelessWidget {
  final Homework homework;

  const _HomeworkCard({required this.homework});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push<void>(
          HomeworkPage.route(id: homework.id!),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              homework.title,
              style: const TextStyle(
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Hạn nộp: ${FormatTime.formatDateTime(homework.dueDate)}',
              style: const TextStyle(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            homework.status == 'submitted'
                ? Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Đã nộp: ${FormatTime.formatDateTime(homework.submittedAt)}',
                        style: const TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  )
                : const Row(
                    children: [
                      Icon(
                        Icons.access_time_filled_sharp,
                        color: Colors.red,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Chưa nộp',
                        style: TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
