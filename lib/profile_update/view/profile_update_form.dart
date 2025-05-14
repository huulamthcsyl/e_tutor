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
      child: SingleChildScrollView(
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
              _BankAccountInput(),
              const SizedBox(height: 16),
              _UpdateButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameInput extends StatefulWidget {
  @override
  State<_NameInput> createState() => _NameInputState();
}

class _NameInputState extends State<_NameInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        if (_controller.text != state.name) {
          _controller.text = state.name;
        }
        return TextFormField(
          key: const Key('profileUpdateForm_nameInput_textField'),
          controller: _controller,
          onChanged: (name) => context.read<ProfileUpdateCubit>().nameChanged(name),
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

class _AddressInput extends StatefulWidget {
  @override
  State<_AddressInput> createState() => _AddressInputState();
}

class _AddressInputState extends State<_AddressInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      buildWhen: (previous, current) => previous.address != current.address,
      builder: (context, state) {
        if (_controller.text != state.address) {
          _controller.text = state.address;
        }
        return TextFormField(
          key: const Key('profileUpdateForm_addressInput_textField'),
          controller: _controller,
          onChanged: (address) => context.read<ProfileUpdateCubit>().addressChanged(address),
          decoration: const InputDecoration(
            labelText: 'Địa chỉ',
          ),
        );
      },
    );
  }
}

class _PhoneNumberInput extends StatefulWidget {
  @override
  State<_PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<_PhoneNumberInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      buildWhen: (previous, current) => previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        if (_controller.text != state.phoneNumber) {
          _controller.text = state.phoneNumber;
        }
        return TextFormField(
          key: const Key('profileUpdateForm_phoneNumberInput_textField'),
          controller: _controller,
          onChanged: (phoneNumber) => context.read<ProfileUpdateCubit>().phoneNumberChanged(phoneNumber),
          decoration: const InputDecoration(
            labelText: 'Số điện thoại',
          ),
          keyboardType: TextInputType.phone,
        );
      },
    );
  }
}

class _BankAccountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      buildWhen: (previous, current) => previous.bankInfos != current.bankInfos,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Ngân hàng',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            DropdownMenu(
              width: 300,
              menuHeight: 300,
              dropdownMenuEntries: state.bankInfos.map((e) => DropdownMenuEntry(value: e.shortName, label: '${e.name} (${e.shortName})')).toList(),
              onSelected: (value) {
                if (value != null) {
                  context.read<ProfileUpdateCubit>().bankChanged(value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('profileUpdateForm_bankAccountInput_textField'),
              onChanged: (accountNumber) => context.read<ProfileUpdateCubit>().bankNumberChanged(accountNumber),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Số tài khoản',
              ),
            ),
          ],
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

