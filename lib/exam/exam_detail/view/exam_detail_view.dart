import 'package:class_repository/class_repository.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:e_tutor/exam/exam_detail/widgets/grade_exam/grade_exam.dart';
import 'package:e_tutor/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:class_repository/class_repository.dart' as class_repository;
import 'package:formz/formz.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../pdf_view/view/pdf_view_page.dart';
import '../cubit/exam_detail_cubit.dart';

class ExamView extends StatelessWidget {
  const ExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamCubit, ExamState>(
      listener: (context, state) {
        if (state.submissionStatus == FormzSubmissionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nộp bài thành công'),
            ),
          );
        }
        if (state.uploadStatus == UploadStatus.uploading) {
          context.loaderOverlay.show();
        } else if (state.uploadStatus == UploadStatus.uploaded) {
          context.loaderOverlay.hide();
        }
      },
      child: LoaderOverlay(
        child: BlocBuilder<ExamCubit, ExamState>(
          builder: (context, state) {
            if (state.status == ExamStatus.loading) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Bài kiểm tra'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  iconTheme: const IconThemeData(color: Colors.white),
                  foregroundColor: Colors.white,
                ),
                body: const Center(child: CircularProgressIndicator()),
              );
            } else if (state.status == ExamStatus.failure) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Bài kiểm tra'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  iconTheme: const IconThemeData(color: Colors.white),
                  foregroundColor: Colors.white,
                ),
                body: const Center(child: Text('Không thể tải bài kiểm tra')),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Bài kiểm tra'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  iconTheme: const IconThemeData(color: Colors.white),
                  foregroundColor: Colors.white,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _ExamInfo(exam: state.exam),
                      if (state.actionStatus == ActionStatus.inProgress) ...[
                        const SizedBox(height: 16),
                        _ExamMaterial(materials: state.exam.materials!)
                      ],
                      if (state.actionStatus != ActionStatus.todo) ...[
                        const SizedBox(height: 16),
                        const _StudentWorks()
                      ],
                      if (state.exam.status == "graded") ...[
                        const SizedBox(height: 16),
                        const _GradeInfo()
                      ],
                      const SizedBox(height: 16),
                      const _ActionButton(),
                    ],
                  ),
                )
              );
            }
          },
        ),
      ),
    );
  }
}

class _ExamInfo extends StatelessWidget {
  const _ExamInfo({required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exam.title ?? "",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text('Thời gian bắt đầu: ${FormatTime.formatDateTime(exam.startTime)}'),
          const SizedBox(height: 4),
          Text('Thời gian kết thúc: ${FormatTime.formatDateTime(exam.endTime)}'),
          if (exam.status != "pending") ...[
            const SizedBox(height: 4),
            Text('Nộp bài lúc: ${FormatTime.formatDateTime(exam.submittedAt)}'),
          ],
        ],
      ),
    );
  }
}

class _ExamMaterial extends StatelessWidget {
  const _ExamMaterial({required this.materials});

  final List<class_repository.Material> materials;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
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
              )),
          for (final material in materials)
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(material.name),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StudentWorks extends StatelessWidget {
  const _StudentWorks();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamCubit, ExamState>(
      buildWhen: (previous, current) => previous.studentWorks != current.studentWorks || previous.actionStatus != current.actionStatus,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bài làm',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              ),
              for (final work in state.studentWorks)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push<void>(
                      PdfViewPage.route(
                        url: work.url,
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            work.name,
                            style: const TextStyle(
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        state.actionStatus == ActionStatus.inProgress ? IconButton(
                          onPressed: () {
                            context.read<ExamCubit>().deleteStudentWork(work);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ) : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              state.actionStatus == ActionStatus.inProgress ?
              GestureDetector(
                onTap: () {
                  context.read<ExamCubit>().uploadStudentWork();
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
                        'Upload bài làm',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  )
                ),
              ) : Container(),
            ],
          ),
        );
      },
    );
  }
}

class _GradeInfo extends StatelessWidget {
  const _GradeInfo();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamCubit, ExamState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Điểm: ${state.exam.score}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamCubit, ExamState>(
      buildWhen: (previous, current) => 
        previous.submissionStatus != current.submissionStatus ||
        previous.actionStatus != current.actionStatus ||
        previous.exam.status != current.exam.status,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.submissionStatus == FormzSubmissionStatus.inProgress ? null :
            () async {
              if (state.user.role == "tutor" && state.exam.status == "submitted") {
                await showDialog(
                  context: context,
                  builder: (_) => GradeExamDialog(exam: state.exam),
                ).then((value) {
                  context.read<ExamCubit>().initialize(state.exam.id!);
                });
                return;
              } else if (state.actionStatus == ActionStatus.todo) {
                context.read<ExamCubit>().startExam();
              } else if (state.actionStatus == ActionStatus.inProgress) {
                context.read<ExamCubit>().submitExam();
              } else {
                return;
              }
            },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.all(12),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: state.submissionStatus == FormzSubmissionStatus.inProgress
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : state.user.role == "tutor"
                  ? state.exam.status == 'pending'
                      ? const Text(
                          "Chưa làm bài",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        )
                      : state.exam.status == 'submitted'
                          ? const Text(
                              "Chấm điểm",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Đã chấm điểm",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            )
                  : Text(
                      state.actionStatus == ActionStatus.notStarted
                          ? "Chưa đến thời gian làm bài"
                          : state.actionStatus == ActionStatus.todo
                              ? "Bắt đầu làm bài"
                              : state.actionStatus == ActionStatus.inProgress
                                  ? "Nộp bài"
                                  : "Đã kết thúc",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
        );
      },
    );
  }
}