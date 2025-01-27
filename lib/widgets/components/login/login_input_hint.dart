import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

class LoginInputHint extends StatelessWidget {
  const LoginInputHint({required this.defaultHint, this.error});

  final String defaultHint;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Text(
      error ?? defaultHint,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: (error != null) ? AppColor.errorOnDark : AppColor.white,
        fontSize: 14,
      ),
    );
  }
}
