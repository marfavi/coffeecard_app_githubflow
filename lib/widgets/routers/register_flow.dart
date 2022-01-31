import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/blocs/register/register_cubit.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/fast_slide_transition.dart';
import 'package:coffeecard/widgets/pages/entry/register/register_email_page.dart';
import 'package:coffeecard/widgets/pages/entry/register/register_name_page.dart';
import 'package:coffeecard/widgets/pages/entry/register/register_passcode_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterFlow extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static Route get route => MaterialPageRoute(builder: (_) => RegisterFlow());
  static const emailRoute = '/';
  static const passcodeRoute = '/passcode';
  static const nameRoute = '/name';

  static void push(String route) => navigatorKey.currentState!.pushNamed(route);

  Future<bool> _didPopRoute() async => navigatorKey.currentState!.maybePop();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _didPopRoute(),
      child: BlocProvider(
        create: (_) => RegisterCubit(repository: sl.get<AccountRepository>()),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              Strings.registerAppBarTitle,
              style: AppTextStyle.pageTitle,
            ),
          ),
          body: Navigator(
            key: navigatorKey,
            onGenerateRoute: _onGenerateRoute,
          ),
        ),
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case emailRoute:
        return FastSlideTransition(child: const RegisterEmailPage());
      case passcodeRoute:
        return FastSlideTransition(child: const RegisterPasscodePage());
      case nameRoute:
        return FastSlideTransition(child: const RegisterNamePage());
      default:
        throw Exception('(RegisterFlow) Unknown route: ${settings.name}');
    }
  }
}