import 'package:formz/formz.dart';

class RequiredText extends FormzInput<String, String> {
  const RequiredText.pure() : super.pure('');
  const RequiredText.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String? value) {
    return value?.isNotEmpty == true ? null : "Không được để trống";
  }
}
