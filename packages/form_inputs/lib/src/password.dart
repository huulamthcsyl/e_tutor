import 'package:formz/formz.dart';

enum PasswordValidationErrors {
  invalid
}

class Password extends FormzInput<String, PasswordValidationErrors> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  @override
  PasswordValidationErrors? validator(String? value) {
    return _passwordRegExp.hasMatch(value ?? '')
      ? null
      : PasswordValidationErrors.invalid;
  }
}