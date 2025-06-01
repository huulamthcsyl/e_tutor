import 'package:e_tutor/profile/profile_update/cubit/profile_update_cubit.dart';
import 'package:e_tutor/utils/time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ProfileUpdateForm extends StatelessWidget {
  const ProfileUpdateForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileUpdateCubit, ProfileUpdateState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: SingleChildScrollView(
        child: BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _AvatarInput(),
                  const SizedBox(height: 16),
                  _NameInput(),
                  const SizedBox(height: 16),
                  _BirthDateInput(),
                  const SizedBox(height: 16),
                  _AddressInput(),
                  const SizedBox(height: 16),
                  _PhoneNumberInput(),
                  if (state.role != 'student') ...[
                    const SizedBox(height: 16),
                    _BankAccountInput(),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 16),
                  _UpdateButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AvatarInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      buildWhen: (previous, current) => previous.avatarUrl != current.avatarUrl,
      builder: (context, state) {
        return Column(
          children: [
            GestureDetector(
              onTap: () => context.read<ProfileUpdateCubit>().pickAvatar(),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: state.avatarUrl != null
                        ? NetworkImage(state.avatarUrl!)
                        : null,
                    child: state.avatarUrl == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nhấn để thay đổi ảnh đại diện',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
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
          onChanged: (name) =>
              context.read<ProfileUpdateCubit>().nameChanged(name),
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
                if (selectedDate != null) {
                  context
                      .read<ProfileUpdateCubit>()
                      .birthDateChanged(selectedDate);
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
          onChanged: (address) =>
              context.read<ProfileUpdateCubit>().addressChanged(address),
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
      buildWhen: (previous, current) =>
          previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        if (_controller.text != state.phoneNumber) {
          _controller.text = state.phoneNumber;
        }
        return TextFormField(
          key: const Key('profileUpdateForm_phoneNumberInput_textField'),
          controller: _controller,
          onChanged: (phoneNumber) => context
              .read<ProfileUpdateCubit>()
              .phoneNumberChanged(phoneNumber),
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
              width: double.infinity,
              menuHeight: 300,
              dropdownMenuEntries: state.bankInfos
                  .map((e) => DropdownMenuEntry(
                      value: e.shortName, label: '${e.name} (${e.shortName})'))
                  .toList(),
              onSelected: (value) {
                if (value != null) {
                  context.read<ProfileUpdateCubit>().bankChanged(value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('profileUpdateForm_bankAccountInput_textField'),
              onChanged: (accountNumber) => context
                  .read<ProfileUpdateCubit>()
                  .bankNumberChanged(accountNumber),
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
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            key: const Key('profileUpdateForm_update_raisedButton'),
            onPressed: state.status.isInProgress
                ? null
                : () => context.read<ProfileUpdateCubit>().submit(),
            child: state.status.isInProgress
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Cập nhật'),
          ),
        );
      },
    );
  }
}
