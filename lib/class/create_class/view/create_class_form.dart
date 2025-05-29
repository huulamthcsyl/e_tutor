import 'package:dotted_border/dotted_border.dart';
import 'package:e_tutor/class/create_class/create_class.dart';
import 'package:e_tutor/utils/format_time.dart';
import 'package:e_tutor/utils/get_day_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:profile_repository/profile_repository.dart';

import '../widgets/add_member/view/add_member_dialog.dart';

class CreateClassForm extends StatelessWidget {
  const CreateClassForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateClassCubit, CreateClassState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("Không thể tạo lớp học")),
            );
        }
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Lớp học đã được tạo")),
          );
          Navigator.of(context).pop();
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _NameInput(),
              const SizedBox(height: 16),
              _DescriptionInput(),
              const SizedBox(height: 16),
              _TuitionInput(),
              const SizedBox(height: 16),
              _ScheduleList(),
              const SizedBox(height: 16),
              _StartDateInput(),
              const SizedBox(height: 16),
              _EndDateInput(),
              const SizedBox(height: 16),
              _ClassMembers(),
              const SizedBox(height: 32),
              _CreateButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateClassCubit, CreateClassState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          onChanged: (value) =>
              context.read<CreateClassCubit>().nameChanged(value),
          decoration: InputDecoration(
            labelText: 'Tên lớp học (*)',
            errorText: state.name.displayError != null
                ? "Tên lớp học không được để trống"
                : null,
          ),
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateClassCubit, CreateClassState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return TextField(
          onChanged: (value) =>
              context.read<CreateClassCubit>().descriptionChanged(value),
          decoration: const InputDecoration(
            labelText: 'Mô tả lớp học',
          ),
        );
      },
    );
  }
}

class _TuitionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateClassCubit, CreateClassState>(
      buildWhen: (previous, current) => previous.tuition != current.tuition,
      builder: (context, state) {
        return TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) =>
              context.read<CreateClassCubit>().tuitionChanged(value),
          decoration: InputDecoration(
            labelText: 'Học phí (*)',
            errorText: state.tuition.displayError != null
                ? "Học phí không được để trống"
                : null,
            suffix: const Text(
              'đ',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
        );
      },
    );
  }
}

class _ScheduleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateClassCubit, CreateClassState>(
      buildWhen: (previous, current) => previous.schedules != current.schedules,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Lịch học',
                  style: TextStyle(fontSize: 18),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => const AddScheduleDialog(),
                    );
                    if (result != null) {
                      context.read<CreateClassCubit>().addSchedule(
                        TimeOfDay.fromDateTime(result[0]),
                        TimeOfDay.fromDateTime(result[1]),
                        result[2],
                      );
                    }
                  },
                ),
              ],
            ),
            for (final schedule in state.schedules)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      '${GetDayName.getDayName(schedule.day.index)}, ${schedule.startTime.format(context)} - ${schedule.endTime.format(context)}',
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        context
                            .read<CreateClassCubit>()
                            .removeSchedule(schedule);
                      },
                    ),
                  ],
                ),
              )
          ],
        );
      },
    );
  }
}

class _StartDateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateClassCubit, CreateClassState>(
      buildWhen: (previous, current) => previous.startDate != current.startDate,
      builder: (context, state) {
        return Row(
          children: [
            const Text(
              'Ngày bắt đầu',
              style: TextStyle(fontSize: 18),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final result = await showDatePicker(
                  context: context,
                  initialDate: state.startDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (result != null) {
                  context.read<CreateClassCubit>().startDateChanged(result);
                }
              },
            ),
            Text(FormatTime.formatDate(state.startDate)),
          ],
        );
      },
    );
  }
}

class _EndDateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateClassCubit, CreateClassState>(
      buildWhen: (previous, current) => previous.endDate != current.endDate,
      builder: (context, state) {
        return Row(
          children: [
            const Text(
              'Ngày kết thúc',
              style: TextStyle(fontSize: 18),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final result = await showDatePicker(
                  context: context,
                  initialDate: state.endDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (result != null) {
                  context.read<CreateClassCubit>().endDateChanged(result);
                }
              },
            ),
            Text(FormatTime.formatDate(state.endDate)),
          ],
        );
      },
    );
  }
}

class _ClassMembers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateClassCubit, CreateClassState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thành viên lớp học',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
                for (final member in state.members)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      spacing: 8,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(member.avatarUrl ?? ''),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.name ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              member.role?.tutorRole() ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            context.read<CreateClassCubit>().removeMember(member);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red
                          )
                        )
                      ],
                    ),
                  ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push<List<Profile>>(
                    AddMemberDialog.route(state.classId),
                  ).then((value) {
                    if (value != null) {
                      context.read<CreateClassCubit>().addMembers(value);
                    }
                  });
                },
                child: DottedBorder(
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
                        'Thêm thành viên',
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

class _CreateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgress = context
        .select((CreateClassCubit cubit) => cubit.state.status.isInProgress);

    if (isInProgress) return const CircularProgressIndicator();

    final isValid =
        context.select((CreateClassCubit cubit) => cubit.state.isValid &&
            cubit.state.members.isNotEmpty &&
            cubit.state.schedules.isNotEmpty);
    return ElevatedButton(
      onPressed:
          isValid ? () => context.read<CreateClassCubit>().createClass() : null,
      child: const Text('Tạo lớp học'),
    );
  }
}

extension on String {
  String tutorRole() {
    switch (this) {
      case 'tutor':
        return 'Gia sư';
      case 'student':
        return 'Học sinh';
      case 'parent':
        return 'Phụ huynh';
      default:
        return '';
    }
  }
}
