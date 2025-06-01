import 'package:dotted_border/dotted_border.dart';
import 'package:e_tutor/utils/time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as date_picker;
import 'package:formz/formz.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../pdf_view/view/pdf_view_page.dart';
import '../cubit/create_exam_cubit.dart';


class CreateExamView extends StatelessWidget {
  const CreateExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExamCubit, CreateExamState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          Navigator.of(context).pop('success');
        }
        if (state.uploadStatus == UploadStatus.uploading) {
          context.loaderOverlay.show();
        } else if (state.uploadStatus == UploadStatus.uploaded) {
          context.loaderOverlay.hide();
        }
      },
      child: LoaderOverlay(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TitleInput(),
              const SizedBox(height: 8),
              _StartTimeInput(),
              const SizedBox(height: 8),
              _EndTimeInput(),
              const SizedBox(height: 8),
              _MaterialsInput(),
              const SizedBox(height: 16),
              _SubmitButton()
            ],
          ),
        ),
      )
    );
  }
}

class _TitleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateExamCubit, CreateExamState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        return TextField(
          onChanged: (title) => context.read<CreateExamCubit>().titleChanged(title),
          decoration: const InputDecoration(
            labelText: 'Tiêu đề bài kiểm tra (*)',
          ),
        );
      },
    );
  }
}

class _StartTimeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateExamCubit, CreateExamState>(
      buildWhen: (previous, current) => previous.startTime != current.startTime,
      builder: (context, state) {
        return Row(
          children: [
            const Text('Thời gian bắt đầu:'),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                date_picker.DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  onConfirm: (date) {
                    context.read<CreateExamCubit>().startTimeChanged(date);
                  },
                  currentTime: state.startTime,
                  locale: date_picker.LocaleType.vi,
                );
              },
              child: Text(
                FormatTime.formatDateTime(state.startTime),
                style: const TextStyle(color: Colors.blue),
              ),
            )
          ],
        );
      },
    );
  }
}

class _EndTimeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateExamCubit, CreateExamState>(
      buildWhen: (previous, current) => previous.endTime != current.endTime,
      builder: (context, state) {
        return Row(
          children: [
           const Text('Thời gian kết thúc:'),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                date_picker.DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  onConfirm: (date) {
                    context.read<CreateExamCubit>().endTimeChanged(date);
                  },
                  currentTime: state.endTime,
                  locale: date_picker.LocaleType.vi,
                );
              },
              child: Text(
                FormatTime.formatDateTime(state.endTime),
                style: const TextStyle(color: Colors.blue),
              ),
            )
          ],
        );
      },
    );
  }
}

class _MaterialsInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateExamCubit, CreateExamState>(
      buildWhen: (previous, current) => previous.materials != current.materials,
      builder: (context, state) {
        return Container(
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
                  )),
              for (final material in state.materials)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push<void>(
                      PdfViewPage.route(
                        url: material.url,
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
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          material.name,
                          style: const TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        IconButton(
                          onPressed: () {
                            context.read<CreateExamCubit>().deleteExamMaterial(material);
                          },
                          icon: const Icon(Icons.delete),
                        )
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  context.read<CreateExamCubit>().uploadMaterial();
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

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isValid = context.select<CreateExamCubit, bool>((cubit) => cubit.state.isValid);
    return BlocBuilder<CreateExamCubit, CreateExamState>(
      buildWhen: (previous, current) => 
        previous.status != current.status || previous.isValid != current.isValid,
      builder: (context, state) {
        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return isValid
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.5);
            }),
            minimumSize: MaterialStateProperty.resolveWith((states) {
              return const Size(double.infinity, 50);
            }),
          ),
          onPressed: isValid && state.status != FormzSubmissionStatus.inProgress
              ? () {
                  context.read<CreateExamCubit>().submit();
                }
              : null,
          child: state.status == FormzSubmissionStatus.inProgress
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Xác nhận',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
        );
      },
    );
  }
}