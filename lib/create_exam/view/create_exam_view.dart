import 'package:dotted_border/dotted_border.dart';
import 'package:e_tutor/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as date_picker;
import 'package:formz/formz.dart';

import '../../pdf_view/view/pdf_view_page.dart';
import '../cubit/create_exam_cubit.dart';


class CreateExamView extends StatelessWidget {
  const CreateExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExamCubit, CreateExamState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          Navigator.of(context).pop();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TitleInput(),
            const SizedBox(height: 8),
            const _StartTimeInput(),
            const _EndTimeInput(),
            _MaterialsInput(),
            const SizedBox(height: 16),
            _SubmitButton()
          ],
        ),
      )
    );
  }
}

class _TitleInput extends StatelessWidget {
  const _TitleInput({super.key});

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
  const _StartTimeInput({super.key});

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
  const _EndTimeInput({super.key});

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
          onPressed: isValid ? () {
            context.read<CreateExamCubit>().submit();
          } : null,
          child: const Text(
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