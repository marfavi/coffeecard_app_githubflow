// ignore_for_file: prefer_const_constructors
import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const username = 'mock-username';
  const password = 'mock-password';
  group('LoginEvent', () {
    group('LoginUsernameChanged', () {
      test('supports value comparisons', () {
        expect(LoginEmailChanged(username), LoginEmailChanged(username));
      });
    });

    group('LoginPasswordChanged', () {
      test('supports value comparisons', () {
        expect(LoginNumpadPressed(password), LoginNumpadPressed(password));
      });
    });

    group('LoginSubmitted', () {
      test('supports value comparisons', () {
        expect(LoginEmailSubmitted(), LoginEmailSubmitted());
      });
    });

    group('LoginGoBack', () {
      test('supports value comparisons', () {
        expect(LoginGoBack(), LoginGoBack());
      });
    });
  });
}