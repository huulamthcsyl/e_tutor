import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as date_picker;
import 'package:loader_overlay/loader_overlay.dart';

import '../../../pdf_view/view/pdf_view_page.dart';
import '../../../utils/format_time.dart';
import '../cubit/create_homework_cubit.dart';

class CreateHomeworkForm extends StatelessWidget {
  const CreateHomeworkForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateHomeworkCubit, CreateHomeworkState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          Navigator.of(context).pop();
        }
        if (state.uploadStatus == UploadStatus.uploading) {
          context.loaderOverlay.show();
        } else if (state.uploadStatus == UploadStatus.uploaded) {
          context.loaderOverlay.hide();
        }
      },
      child: LoaderOverlay(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _TitleInput(),
                  const SizedBox(height: 16),
                  _MaterialsInput(),
                  const SizedBox(height: 16),
                  _DueDateInput(),
                  const SizedBox(height: 16),
                  _SubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateHomeworkCubit, CreateHomeworkState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        return TextFormField(
          initialValue: state.title.value,
          onChanged: (title) {
            context.read<CreateHomeworkCubit>().updateTitle(title);
          },
          decoration: InputDecoration(
            labelText: 'Tiêu đề (*)',
            errorText: state.title.displayError != null ? 'Tiêu đề không được để trống' : null,
          ),
        );
      },
    );
  }
}

class _MaterialsInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateHomeworkCubit, CreateHomeworkState>(
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
                            context.read<CreateHomeworkCubit>().deleteMaterial(material);
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
                  context.read<CreateHomeworkCubit>().uploadMaterial();
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

class _DueDateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateHomeworkCubit, CreateHomeworkState>(
      buildWhen: (previous, current) => previous.dueDate != current.dueDate,
      builder: (context, state) {
        return Row(
          children: [
            const Text('Hạn nộp bài: '),
            TextButton(
              onPressed: () async {
                date_picker.DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime.now().add(const Duration(days: 365)),
                  onConfirm: (date) {
                    context.read<CreateHomeworkCubit>().updateDueDate(date);
                  },
                  currentTime: state.dueDate,
                  locale: date_picker.LocaleType.vi,
                );
              },
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  Text(FormatTime.formatDateTime(state.dueDate)),
                ],
              )
            ),
          ],
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isValid = context.select((CreateHomeworkCubit cubit) => cubit.state.isValid);
    return BlocBuilder<CreateHomeworkCubit, CreateHomeworkState>(
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
          onPressed: isValid
              ? () {
                  context.read<CreateHomeworkCubit>().submit();
                }
              : null,
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