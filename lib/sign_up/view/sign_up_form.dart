import 'package:e_tutor/login/view/login_page.dart';
import 'package:e_tutor/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if(state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? "Không thể đăng ký")),
            );
        }
        if(state.status.isSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (_) => const LoginPage()),
          );
        }
      },
      child: Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.1,),
                Text(
                  'Đăng ký',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                _EmailInput(),
                _FullnameInput(),
                _PasswordInput(),
                _ConfirmedPasswordInput(),
                _RoleSelector(),
                const SizedBox(height: 16),
                _SignUpButton(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Đã có tài khoản?', 
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    _LoginButton(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email (*)',
            helperText: '',
            errorText: state.email.displayError != null ? "Email không hợp lệ" : null,
          ),
        );
      },
    );
  }
}

class _FullnameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.fullName != current.fullName,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_fullNameInput_textField'),
          onChanged: (fullName) => context.read<SignUpCubit>().fullNameChanged(fullName),
          decoration: InputDecoration(
            labelText: 'Họ và tên (*)',
            helperText: '',
            errorText: state.fullName.displayError != null ? "Họ và tên không hợp lệ" : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) => context.read<SignUpCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mật khẩu (*)',
            helperText: '',
            errorText: state.password.displayError != null ? "Mật khẩu không hợp lệ" : null,
          ),
        );
      },
    );
  }
}

class _ConfirmedPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          onChanged: (confirmedPassword) => context.read<SignUpCubit>().confirmedPasswordChanged(confirmedPassword),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Xác nhận mật khẩu (*)',
            helperText: '',
            errorText: state.confirmedPassword.displayError != null ? "Mật khẩu xác nhận không khớp" : null,
          ),
        );
      },
    );
  }
}

class _RoleSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.role != current.role,
      builder: (context, state) {
        return Row(
          children: [
            Text(
              'Vai trò (*)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 16),
            DropdownMenu<String>(
              initialSelection: 'student',
              onSelected: (value) => context.read<SignUpCubit>().roleChanged(value ?? 'student'),
              dropdownMenuEntries: const [
                DropdownMenuEntry(
                  value: 'student',
                  label: 'Học sinh',
                ),
                DropdownMenuEntry(
                  value: 'tutor',
                  label: 'Gia sư',
                ),
                DropdownMenuEntry(
                  value: 'parent',
                  label: 'Phụ huynh',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select((SignUpCubit cubit) => cubit.state.status.isInProgress);

    if (isInProgress) return const CircularProgressIndicator();

    final isValid = context.select((SignUpCubit cubit) => cubit.state.isValid);

    return ElevatedButton(
      key: const Key('signUpForm_continue_raisedButton'),
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
        ? () => context.read<SignUpCubit>().signUpWithCredentials()
        : null,
      child: const Text(
        'Đăng ký',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: const Key('signUpForm_login_textButton'),
      onPressed: () => Navigator.of(context).pop(),
      child: const Text(
        'Đăng nhập',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    );
  }
}