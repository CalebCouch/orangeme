import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/tip_buttons.dart';
import 'package:orange/components/tabular.dart';

import 'package:orange/flows/wallet/send/send.dart';

import 'package:orange/util.dart';

class DataItem extends StatelessWidget {
  final String title;
  final int? listNum;
  final Widget content;
  final List<String>? buttonNames;
  final List<VoidCallback>? buttonActions;
  final List<String>? buttonIcons;

  const DataItem({
    super.key,
    required this.title,
    this.listNum,
    required this.content,
    this.buttonNames,
    this.buttonActions,
    this.buttonIcons,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          listNum != null
              ? Row(
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
                  ],
                )
              : Container(),
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
                  buttonNames != null &&
                          buttonActions != null &&
                          buttonNames!.length == 1
                      ? editButtons([
                          ButtonTip(
                            buttonNames![0],
                            buttonIcons == null
                                ? ThemeIcon.edit
                                : buttonIcons![0],
                            buttonActions![0],
                          ),
                        ])
                      : buttonNames != null &&
                              buttonActions != null &&
                              buttonNames!.length == 2
                          ? editButtons([
                              ButtonTip(
                                buttonNames![0],
                                buttonIcons == null
                                    ? ThemeIcon.edit
                                    : buttonIcons![0],
                                buttonActions![0],
                              ),
                              ButtonTip(
                                buttonNames![1],
                                buttonIcons == null
                                    ? ThemeIcon.edit
                                    : buttonIcons![1],
                                buttonActions![1],
                              ),
                            ])
                          : Container(),
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
  return oneTip(tipButtons[0]);
}

Widget two(List<ButtonTip> tipButtons) {
  return Row(
    children: [
      oneTip(tipButtons[0]),
      const Spacing(width: AppPadding.tips),
      oneTip(tipButtons[1]),
    ],
  );
}

Widget aboutMeItem(BuildContext context, String aboutMe) {
  return DataItem(
    title: 'About Me',
    content: Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.dataItem),
      child: CustomText(
        alignment: TextAlign.left,
        text: aboutMe,
        textSize: TextSize.h5,
      ),
    ),
  );
}

Widget addressItem(BuildContext context, String address) {
  return DataItem(
    title: 'Bitcoin address',
    content: Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.dataItem),
      child: CustomText(
        alignment: TextAlign.left,
        text: address,
        textSize: TextSize.h5,
      ),
    ),
    buttonNames: const ['Copy'],
    buttonIcons: const [ThemeIcon.copy],
    buttonActions: [
      () async {
        await Clipboard.setData(ClipboardData(text: address));
      },
    ],
  );
}

Widget didItem(BuildContext context, String did) {
  return DataItem(
    title: 'Digital ID',
    content: Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.dataItem),
      child: CustomText(
        alignment: TextAlign.left,
        text: did,
        textSize: TextSize.h5,
      ),
    ),
    buttonNames: const ['Copy'],
    buttonIcons: const [ThemeIcon.copy],
    buttonActions: [
      () async {
        await Clipboard.setData(ClipboardData(text: did));
      },
    ],
  );
}

Widget confirmRecipientItem(GlobalState globalState, BuildContext context,
    String recipient, String did) {
  return DataItem(
    title: "Confirm contact",
    listNum: 1,
    content: Column(
      children: [
        const Spacing(height: AppPadding.bumper),
        contactTabular(
          context,
          recipient,
          did,
        ),
        const Spacing(height: AppPadding.bumper),
        const CustomText(
          textSize: TextSize.sm,
          color: ThemeColor.textSecondary,
          alignment: TextAlign.left,
          text: "Bitcoin sent to the wrong address can never be recovered.",
        ),
        const Spacing(height: AppPadding.bumper),
      ],
    ),
    buttonNames: const ["Recipient"],
    buttonActions: [
      () {
        navigateTo(context, Send(globalState));
      }
    ],
  );
}
