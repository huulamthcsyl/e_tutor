import 'package:e_tutor/profile_update/cubit/profile_update_cubit.dart';
import 'package:e_tutor/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ProfileUpdateForm extends StatelessWidget {
  const ProfileUpdateForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileUpdateCubit, ProfileUpdateState>(
      listener: (context, state) {
        if(state.status.isSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _NameInput(),
            const SizedBox(height: 16),
            _BirthDateInput(),
            const SizedBox(height: 16),
            _AddressInput(),
            const SizedBox(height: 16),
            _PhoneNumberInput(),
            const SizedBox(height: 16),
            _UpdateButton(),
          ],
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextFormField(
          key: const Key('profileUpdateForm_nameInput_textField'),
          onChanged: (name) => context.read<ProfileUpdateCubit>().nameChanged(name),
          initialValue: state.name,
          decoration: const InputDecoration(
            labelText: 'Họ và tên',
          ),
        );
      },
    );
  }
}

class _BirthDateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      buildWhen: (previous, current) => previous.birthDate != current.birthDate,
      builder: (context, state) {
        return Row(
          children: [
            const Text('Ngày sinh'),
            const Spacer(),
            IconButton(
              key: const Key('profileUpdateForm_birthDateInput_iconButton'),
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: state.birthDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if(selectedDate != null) {
                  context.read<ProfileUpdateCubit>().birthDateChanged(selectedDate);
                }
              },
            ),
            Text(
              FormatTime.formatDate(state.birthDate),
              key: const Key('profileUpdateForm_birthDateInput_textField'),
            ),
          ],
        );
      },
    );
  }
}

class _AddressInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      buildWhen: (previous, current) => previous.address != current.address,
      builder: (context, state) {
        return TextFormField(
          key: const Key('profileUpdateForm_addressInput_textField'),
          onChanged: (address) => context.read<ProfileUpdateCubit>().addressChanged(address),
          initialValue: state.address,
          decoration: const InputDecoration(
            labelText: 'Địa chỉ',
          ),
        );
      },
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      buildWhen: (previous, current) => previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        return TextFormField(
          key: const Key('profileUpdateForm_phoneNumberInput_textField'),
          onChanged: (phoneNumber) => context.read<ProfileUpdateCubit>().phoneNumberChanged(phoneNumber),
          initialValue: state.phoneNumber,
          decoration: const InputDecoration(
            labelText: 'Số điện thoại',
          ),
          keyboardType: TextInputType.phone,
        );
      },
    );
  }
}

class _UpdateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      builder: (context, state) {
        return ElevatedButton(
          key: const Key('profileUpdateForm_update_raisedButton'),
          onPressed: () => context.read<ProfileUpdateCubit>().submit(),
          child: const Text('Cập nhật'),
        );
      },
    );
  }
}

