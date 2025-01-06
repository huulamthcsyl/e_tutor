import 'package:class_repository/class_repository.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:e_tutor/lesson/lesson.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  _ClassInfo(classData: state.classData),
                  const SizedBox(height: 16),
                  _MaterialInfo(lesson: state.lessonData),
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

  const _ClassInfo({required this.classData});

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
          const Text(
            'Thông tin lớp học', 
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
          )),
          const SizedBox(height: 8),
          RichText(text: TextSpan(
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
          RichText(text: TextSpan(
            text: 'Mô tả: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: classData.description ?? "",
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

  const _MaterialInfo({required this.lesson});

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
              const Text(
                'Tài liệu', 
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              ),
              for (final material in state.materials)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Tên tài liệu: ${material}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  context.read<LessonCubit>().uploadMaterial();
                },
                child: DottedBorder(
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
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

