import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';

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
    return Container(
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
                  Row(
                    children: [
                      for (int i = 0; i < buttons; i++)
                        CustomButton(
                          icon: ThemeIcon.edit,
                          text: buttonNames[i],
                          buttonSize: ButtonSize.md,
                          variant: ButtonVariant.secondary,
                          expand: false,
                          onTap: buttonActions[i],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
