import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/utils/input_validator.dart';
import 'package:coffeecard/widgets/components/forms/form.dart';
import 'package:flutter/material.dart';

class RegisterPasscodeRepeatForm extends StatelessWidget {
  const RegisterPasscodeRepeatForm({
    required this.passcode,
    required this.onSubmit,
  });

  final String passcode;
  final void Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return FormBase(
      inputValidators: [
        InputValidators.nonEmptyString(
          errorMessage: Strings.registerPasscodeEmpty,
        ),
        InputValidator.bool(
          validate: (text) => text.length == 4,
          errorMessage: Strings.registerPasscodeTooShort,
        ),
        InputValidator.bool(
          forceErrorMessage: true,
          validate: (text) => text == passcode,
          errorMessage: Strings.registerPasscodeDoesNotMatch,
        ),
      ],
      title: Strings.registerPasscodeRepeatTitle,
      label: Strings.registerPasscodeRepeatLabel,
      type: TextFieldType.passcode,
      autoSubmitValidInput: true,
      onSubmit: onSubmit,
    );
  }
}
