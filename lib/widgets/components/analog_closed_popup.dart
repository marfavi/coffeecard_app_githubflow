import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/analog_closed_popup/analog_closed_popup_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/widgets/components/rounded_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalogClosedPopup extends StatelessWidget {
  const AnalogClosedPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalogClosedPopupCubit(),
      child: BlocBuilder<AnalogClosedPopupCubit, AnalogClosedPopupState>(
        builder: (context, state) {
          if (state is AnalogClosedPopupError) {
            return const Text('error');
          } else if (state is AnalogClosedPopupHidden) {
            return const SizedBox.shrink();
          } else if (state is AnalogClosedPopupLoading) {
            final analogClosedPopupCubit =
                context.read<AnalogClosedPopupCubit>();
            analogClosedPopupCubit.getOpeninghours();
            return const Text('loading');
          } else if (state is AnalogClosedPopupVisible) {
            return Container(
              color: AppColor.secondary,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      Strings.analogClosedText,
                      style: AppTextStyle.buttonText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      //FIXME: write message
                      'Oh no!',
                      style: AppTextStyle.buttonText,
                    ),
                  ),
                  RoundedButton(
                    text: Strings.buttonGotIt,
                    onPressed: () {
                      final analogClosedPopupCubit =
                          context.read<AnalogClosedPopupCubit>();
                      analogClosedPopupCubit.closePopup();
                    },
                  )
                ],
              ),
            );
          }
          //FIXME: provide meaningfull error, maybe pass widget name?
          throw MatchCaseIncompleteException('match cases incomplete');
        },
      ),
    );
  }
}