import 'package:class_repository/class_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as date_picker;
import 'package:formz/formz.dart';

import '../../../../../utils/format_time.dart';
import '../cubit/create_lesson_cubit.dart';

class CreateLessonDialog extends StatelessWidget {
  const CreateLessonDialog({super.key});

  static BlocProvider<CreateLessonCubit> route(String classId) {
    return BlocProvider(
      create: (context) => CreateLessonCubit(
        context.read<ClassRepository>(),
      )..init(classId),
      child: const CreateLessonDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateLessonCubit, CreateLessonState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          Navigator.of(context).pop("success");
        }
      },
      child: BlocBuilder<CreateLessonCubit, CreateLessonState>(
        builder: (context, state) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tạo buổi học',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Text('Bắt đầu: '),
                      TextButton(
                        onPressed: () {
                          date_picker.DatePicker.showDateTimePicker(
                            context,
                            showTitleActions: true,
                            onConfirm: (time) {
                              context.read<CreateLessonCubit>().startTimeChanged(time);
                            },
                            currentTime: state.startTime,
                            locale: date_picker.LocaleType.vi,
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month),
                            const SizedBox(width: 8),
                            Text(FormatTime.formatDateTime(state.startTime))
                          ],
                        )
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Kết thúc: '),
                      TextButton(
                        onPressed: () {
                          date_picker.DatePicker.showDateTimePicker(
                            context,
                            showTitleActions: true,
                            onConfirm: (time) {
                              context.read<CreateLessonCubit>().endTimeChanged(time);
                            },
                            currentTime: state.endTime,
                            locale: date_picker.LocaleType.vi,
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month),
                            const SizedBox(width: 8),
                            Text(FormatTime.formatDateTime(state.endTime))
                          ],
                        )
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Huỷ"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CreateLessonCubit>().submit(context);
                        },
                        child: const Text('Tạo'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
