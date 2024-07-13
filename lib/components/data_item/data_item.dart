import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';

import 'package:orange/components/buttons/tip_buttons.dart';

class DataItem extends StatelessWidget {
  final String title;
  final int listNum;
  final Widget content;
  final List<String> buttonNames;
  final List<VoidCallback> buttonActions;

  const DataItem({
    super.key,
    required this.title,
    required this.listNum,
    required this.content,
    required this.buttonNames,
    required this.buttonActions,
  });

  @override
  Widget build(BuildContext context) {
    int buttons = buttonNames.length;
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            height: 32,
            width: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeColor.bgSecondary,
            ),
            child: CustomText(
              textType: 'heading',
              textSize: TextSize.h6,
              text: listNum.toString(),
            ),
          ),
          const Spacing(width: AppPadding.bumper),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    alignment: TextAlign.left,
                    text: title,
                    textSize: TextSize.h5,
                    textType: 'heading',
                  ),
                  content,
                  buttonNames.length == 1
                      ? editButtons([
                          ButtonTip(
                            buttonNames[0],
                            ThemeIcon.edit,
                            buttonActions[0],
                          ),
                        ])
                      : editButtons([
                          ButtonTip(
                            buttonNames[0],
                            ThemeIcon.edit,
                            buttonActions[0],
                          ),
                          ButtonTip(
                            buttonNames[1],
                            ThemeIcon.edit,
                            buttonActions[1],
                          ),
                        ]),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget editButtons(List<ButtonTip> tipButtons) {
  if (tipButtons.length == 1) return one(tipButtons);
  if (tipButtons.length == 2) return two(tipButtons);
  return Container();
}

Widget one(List<ButtonTip> tipButtons) {
  return TipButtonStack(buttons: tipButtons);
}

Widget two(List<ButtonTip> tipButtons) {
  return Row(
    children: [
      TipButtonStack(buttons: [tipButtons[0]]),
      const Spacing(width: AppPadding.tips),
      TipButtonStack(buttons: [tipButtons[1]]),
    ],
  );
}
