import 'package:e_tutor/create_class/create_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

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
            const SizedBox(height: 32),
            _CreateButton(),
          ],
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
                      'Từ ${schedule.startTime.format(context)} đến ${schedule.endTime.format(context)}',
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete),
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

class _CreateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgress = context
        .select((CreateClassCubit cubit) => cubit.state.status.isInProgress);

    if (isInProgress) return const CircularProgressIndicator();

    final isValid =
        context.select((CreateClassCubit cubit) => cubit.state.isValid);
    return ElevatedButton(
      onPressed:
          isValid ? () => context.read<CreateClassCubit>().createClass() : null,
      child: const Text('Tạo lớp học'),
    );
  }
}
