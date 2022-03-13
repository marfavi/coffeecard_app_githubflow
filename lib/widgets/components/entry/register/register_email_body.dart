import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/register/register_cubit.dart';
import 'package:coffeecard/utils/debouncer.dart';
import 'package:coffeecard/utils/email_utils.dart';
import 'package:coffeecard/widgets/components/continue_button.dart';
import 'package:coffeecard/widgets/components/forms/text_field.dart';
import 'package:coffeecard/widgets/routers/register_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterEmailBody extends StatefulWidget {
  const RegisterEmailBody();
  @override
  State<RegisterEmailBody> createState() => _RegisterEmailBodyState();
}

class _RegisterEmailBodyState extends State<RegisterEmailBody> {
  final _controller = TextEditingController();
  final _debounce = Debouncer(delay: const Duration(milliseconds: 250));

  bool _loading = false;
  bool _showError = false;
  bool _readOnly = false;
  String? _validatedEmail;
  bool get _validated => _validatedEmail == _controller.text;

  String? _error;
  String? get error => _error;
  set error(String? error) {
    setState(() => _error = error);
  }

  String? get errorMessage => _showError ? _error : null;

  Future<void> _validateEmail(String email) async {
    final _email = email.trim();
    if (_email.isEmpty) {
      error = Strings.registerEmailEmpty;
    } else if (!emailIsValid(_email)) {
      error = Strings.registerEmailInvalid;
    } else {
      final isDuplicate = await emailIsDuplicate(_email);
      if (!mounted) return; // Needs to be checked after an async call.
      if (isDuplicate) {
        _showError = true;
        error = '$_email ${Strings.registerEmailInUseSuffix}';
      } else {
        error = null;
      }
    }
    setState(() {
      _validatedEmail = (error == null) ? email : null;
      _loading = false;
    });
  }

  void _onChanged() {
    setState(() => _loading = true);
    _debounce(() => _validateEmail(_controller.text));
  }

  Future<void> _submit(BuildContext context) async {
    if (_loading) {
      _debounce.dispose();
      setState(() => _readOnly = true);
      await _validateEmail(_controller.text);
    }
    if (!mounted) return;
    if (_validated) {
      context.read<RegisterCubit>().setEmail(_controller.text);
      RegisterFlow.push(RegisterFlow.passcodeRoute);
    }
    setState(() {
      _readOnly = false;
      _showError = true;
    });
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          AppTextField(
            label: Strings.registerEmailLabel,
            hint: Strings.registerEmailHint,
            autofocus: true,
            error: errorMessage,
            type: TextFieldType.email,
            loading: _loading,
            showCheckMark: _validated,
            readOnly: _readOnly,
            onChanged: _onChanged,
            onEditingComplete: () => _submit(context),
            controller: _controller,
          ),
          ContinueButton(
            onPressed: () => _submit(context),
            enabled: _validated,
          )
        ],
      ),
    );
  }
}