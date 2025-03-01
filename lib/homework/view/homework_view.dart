import 'package:class_repository/class_repository.dart' as class_repo;
import 'package:e_tutor/homework/cubit/homework_cubit.dart';
import 'package:e_tutor/pdf_view/view/pdf_view_page.dart';
import 'package:e_tutor/utils/format_time.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomeworkView extends StatelessWidget {
  const HomeworkView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeworkCubit, HomeworkState>(builder: (context, state) {
      switch (state.status) {
        case HomeworkStatus.loading:
          return const Center(child: CircularProgressIndicator());
        case HomeworkStatus.success:
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
                    Text(FormatTime.formatDate(state.homework.dueDate)),
                  ],
                ),
                const SizedBox(height: 8),
                if (state.homework.materials != null)
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
                        for (final material in state.homework.materials!)
                          _MaterialView(material: material),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                if (state.homework.studentWorks != null)
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
                        for (final studentWork in state.homework.studentWorks!)
                          _StudentWork(studentWork: studentWork),
                      ],
                    ),
                  ),  
              ],
            ),
          );
        default:
          return const Center(child: Text('Không thể tải tài liệu!'));
      } 
    });
  }
}

class _MaterialView extends StatelessWidget {
  final class_repo.Material material;
  const _MaterialView({super.key, required this.material});

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
  const _StudentWork({super.key, required this.studentWork});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        studentWork.name,
        style: const TextStyle(
          fontSize: 16,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
