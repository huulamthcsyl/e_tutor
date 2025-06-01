import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/class/create_class/create_class.dart';
import 'package:e_tutor/utils/day_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class AddScheduleDialog extends StatelessWidget {
  const AddScheduleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddScheduleCubit>(
          create: (_) => AddScheduleCubit(),
        ),
        BlocProvider<CreateClassCubit>(
          create: (_) => CreateClassCubit(
            context.read<ClassRepository>(),
            context.read<AuthenticationRepository>(),
            context.read<ProfileRepository>(),
          ),
        ),
      ],
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Thêm thời gian học'),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Bắt đầu:'),
                  const SizedBox(width: 16),
                  _StartTimeInput(),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Kết thúc:'),
                  const SizedBox(width: 16),
                  _EndTimeInput(),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Ngày:'),
                  const SizedBox(width: 16),
                  _DayInput(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _CancelButton(),
                  _AddButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartTimeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleCubit, AddScheduleState>(
      buildWhen: (previous, current) => previous.startTime != current.startTime,
      builder: (context, state) {
        return TimePickerSpinnerPopUp(
          initTime: state.startTime,
          onChange: (time) {
            context.read<AddScheduleCubit>().startTimeChanged(time);
          },
          cancelText: 'Hủy',
          confirmText: 'Chọn',
        );
      },
    );
  }
}

class _EndTimeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleCubit, AddScheduleState>(
      buildWhen: (previous, current) => previous.endTime != current.endTime,
      builder: (context, state) {
        return TimePickerSpinnerPopUp(
          initTime: state.endTime,
          onChange: (time) {
            context.read<AddScheduleCubit>().endTimeChanged(time);
          },
          cancelText: 'Hủy',
          confirmText: 'Chọn',
        );
      },
    );
  }
}

class _DayInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleCubit, AddScheduleState>(
      buildWhen: (previous, current) => previous.day != current.day,
      builder: (context, state) {
        return DropdownButton<DayInWeek>(
          value: state.day,
          onChanged: (value) {
            context.read<AddScheduleCubit>().dayChanged(value ?? DayInWeek.Monday);
          },
          items: DayInWeek.values
              .map(
                (day) => DropdownMenuItem(
                  value: day,
                  child: Text(
                    GetDayName.getDayName(day.index),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text(
        'Hủy',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleCubit, AddScheduleState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop([state.startTime, state.endTime, state.day]);
          },
          child: const Text('Thêm'),
        );
      },
    );
  }
}
