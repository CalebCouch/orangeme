import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/tabular.dart';

import 'package:orange/flows/bitcoin/send/send.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

// This code defines a DataItem widget for displaying content with optional
// labels and buttons, and includes functions for creating specific DataItem
// variations like aboutMeItem and addressItem.

/* A versatile widget for displaying a title, content, and optional buttons. Supports dynamic button actions and icons. */
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

/* A function that arranges ButtonTip widgets based on the number of provided buttons (1 or 2). */
Widget editButtons(List<ButtonTip> tipButtons) {
  if (tipButtons.length == 1) return one(tipButtons);
  if (tipButtons.length == 2) return two(tipButtons);
  return Container();
}

/* Returns a single ButtonTip widget. */
Widget one(List<ButtonTip> tipButtons) {
  return ButtonTip(tipButtons[0].text, tipButtons[0].icon, tipButtons[0].onTap);
}

/* Returns a row of two ButtonTip widgets. */
Widget two(List<ButtonTip> tipButtons) {
  return Row(
    children: [
      ButtonTip(tipButtons[0].text, tipButtons[0].icon, tipButtons[0].onTap),
      const Spacing(width: AppPadding.tips),
      ButtonTip(tipButtons[1].text, tipButtons[1].icon, tipButtons[1].onTap),
    ],
  );
}

/* Creates a DataItem displaying an "About Me" section with the provided text. */
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

/* Creates a DataItem for displaying a Bitcoin address with a "Copy" button to copy the address to the clipboard. */
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
        HapticFeedback.heavyImpact();
        await Clipboard.setData(ClipboardData(text: address));
      },
    ],
  );
}

/* Creates a DataItem for displaying a Digital ID with a "Copy" button to copy the ID to the clipboard. */
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
        HapticFeedback.heavyImpact();
        await Clipboard.setData(ClipboardData(text: did));
      },
    ],
  );
}

/*  Creates a DataItem for confirming a recipient's details before sending Bitcoin, with a button to navigate to a send screen. */
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
