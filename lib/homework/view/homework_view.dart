import 'package:class_repository/class_repository.dart' as class_repo;
import 'package:dotted_border/dotted_border.dart';
import 'package:e_tutor/homework/widgets/grade_homework/views/grade_homework_dialog.dart';
import 'package:e_tutor/pdf_view/view/pdf_view_page.dart';
import 'package:e_tutor/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:profile_repository/profile_repository.dart';

import '../cubit/homework_cubit.dart';

class HomeworkView extends StatelessWidget {
  final class_repo.Homework homework;
  final Profile user;
  final List<class_repo.Material> studentWorks;
  const HomeworkView({super.key, required this.homework, required this.user, required this.studentWorks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Đến hạn: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(FormatTime.formatDateTime(homework.dueDate)),
            ],
          ),
          const SizedBox(height: 8),
          homework.submittedAt != null
            ? Row(
              children: [
                const Text(
                  'Đã nộp: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(FormatTime.formatDateTime(homework.submittedAt!)),
              ],
            )
            : Container(),
          const SizedBox(height: 8),
          if (homework.materials != null)
            Container(
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
                  const Text(
                    'Tài liệu:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: double.infinity,
                    child: (){
                      if (homework.materials!.isEmpty) {
                        return const Text('Không có tài liệu');
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: homework.materials!.length,
                        itemBuilder: (context, index) {
                          final material = homework.materials![index];
                          return _MaterialView(material: material);
                        },
                      );
                    }(),
                  ),
                ],
              ),
            ),
          if (homework.studentWorks != null)
            Container(
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
                  const Text(
                    'Bài làm:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: double.infinity,
                    child: (){
                      if (studentWorks.isEmpty) {
                        return const Text('Chưa có bài làm');
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: studentWorks.length,
                        itemBuilder: (context, index) {
                          final studentWork = studentWorks[index];
                          return _StudentWork(studentWork: studentWork, status: homework.status);
                        },
                      );
                    }(),
                  ),
                  user.role == "student" && homework.status == 'pending'
                    ? GestureDetector(
                      onTap: () {
                        context.read<HomeworkCubit>().uploadStudentWork();
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
                              'Tải bài làm',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        )
                      ),
                    )
                    : Container(),
                ],
              ),
            ),
          if (homework.status == 'graded')
            _GradeInfo(homework: homework),
          if (homework.status == 'pending' && user.role == 'student')
            _SubmitButton(homework: homework),
          if (homework.status == 'submitted' && user.role == 'tutor')
            _GradeButton(homework: homework),
        ],
      ),
    );
  }
}

class _MaterialView extends StatelessWidget {
  final class_repo.Material material;
  const _MaterialView({required this.material});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PdfViewPage.route(url: material.url));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 8),
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
        child: Text(
          material.name,
          style: const TextStyle(
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _StudentWork extends StatelessWidget {
  final class_repo.Material studentWork;
  final String? status;
  const _StudentWork({required this.studentWork, required this.status});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PdfViewPage.route(url: studentWork.url));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 8),
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
        child: Row(
          children: [
            Text(
              studentWork.name,
              style: const TextStyle(
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            status == "pending" ? IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<HomeworkCubit>().deleteStudentWork(studentWork);
              },
            ) : Container(),
          ],
        )
      ),
    );
  }
}

class _GradeInfo extends StatelessWidget {
  final class_repo.Homework homework;
  const _GradeInfo({required this.homework});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Text(
            'Kết quả:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              const Text('Điểm:'),
              const SizedBox(width: 8),
              Text(homework.score.toString()),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Phản hồi:'),
              const SizedBox(width: 16),
              Text(homework.feedback ?? ""),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final class_repo.Homework homework;
  const _SubmitButton({required this.homework});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<HomeworkCubit>().submit();
        Navigator.of(context).pop();
      },
      child: const Text('Nộp bài'),
    );
  }
}

class _GradeButton extends StatelessWidget {
  final class_repo.Homework homework;
  const _GradeButton({required this.homework});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (_) => GradeHomeworkDialog(homework: homework),
        ).then((value) {
          context.read<HomeworkCubit>().initialize(homework.id!);
        });
      },
      child: const Text('Chấm điểm'),
    );
  }
}
