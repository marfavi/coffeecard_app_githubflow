import 'package:coffeecard/base/strings_environment.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AppScaffold extends StatelessWidget {
  final Widget? title;
  final Widget body;
  final Color backgroundColor;
  final bool resizeToAvoidBottomInset;
  final double? appBarHeight;

  /// A Scaffold with a normal app bar.
  /// The body's background color is always `AppColor.background`.
  AppScaffold.withTitle({
    required String title,
    this.resizeToAvoidBottomInset = true,
    required this.body,
  })  : title = Text(title, style: AppTextStyle.pageTitle),
        backgroundColor = AppColor.background,
        appBarHeight = null; // Use default app bar height

  /// A Scaffold with an empty, 24 dp tall app bar.
  /// The body's background color is, by default, the same as the app bar.
  const AppScaffold.withoutTitle({
    this.backgroundColor = AppColor.primary,
    this.resizeToAvoidBottomInset = true,
    required this.body,
  })  : title = null,
        appBarHeight = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      // The background color is set to avoid a thin line
      // between the AppBar and the _EnvironmentBanner.
      // The actual background of the body is defined
      // in the child of the Expanded widget below.
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        title: title,
        elevation: 0,
        toolbarHeight: appBarHeight,
      ),
      body: BlocBuilder<EnvironmentCubit, EnvironmentState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state is EnvironmentLoaded && state.isTestEnvironment)
                const _EnvironmentBanner(tappable: true),
              Expanded(
                child: Container(
                  color: backgroundColor,
                  child: body,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// TODO: Extract to its own file as more widgets want to use this widget
class _EnvironmentBanner extends StatelessWidget {
  const _EnvironmentBanner({required this.tappable});
  final bool tappable;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primary,
      padding: const EdgeInsets.only(bottom: 2),
      child: Center(
        child: _EnvironmentButton(tappable: tappable),
      ),
    );
  }
}

class _EnvironmentButton extends StatelessWidget {
  const _EnvironmentButton({required this.tappable});
  final bool tappable;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: tappable
          ? () => appDialog(
                context: context,
                title: TestEnvironmentStrings.title,
                children: [
                  Text(
                    TestEnvironmentStrings.description[0],
                    style: AppTextStyle.settingKey,
                  ),
                  const Gap(8),
                  Text(
                    TestEnvironmentStrings.description[1],
                    style: AppTextStyle.settingKey,
                  ),
                  const Gap(8),
                  Text(
                    TestEnvironmentStrings.description[2],
                    style: AppTextStyle.settingKey,
                  ),
                ],
                actions: [
                  TextButton(
                    child: const Text(TestEnvironmentStrings.understood),
                    onPressed: () => closeAppDialog(context),
                  ),
                ],
                dismissible: true,
              )
          : null,
      style: TextButton.styleFrom(
        backgroundColor: AppColor.white,
        padding: const EdgeInsets.only(left: 16, right: 12),
        shape: const StadiumBorder(),
        visualDensity: VisualDensity.comfortable,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            TestEnvironmentStrings.title,
            style: AppTextStyle.environmentNotifier,
          ),
          if (tappable) const Gap(8),
          if (tappable)
            const Icon(
              Icons.info_outline,
              color: AppColor.primary,
              size: 18,
            ),
        ],
      ),
    );
  }
}
