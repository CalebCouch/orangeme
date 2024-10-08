import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/util.dart';
import 'package:orangeme_material/orangeme_material.dart';

class DataItem extends StatelessWidget {
  final String title;
  final Widget? content;
  final int? number;
  final String? subtitle;
  final String? helperText;
  final List<CustomButton>? buttons;

  const DataItem({
    super.key,
    required this.title,
    this.number,
    this.subtitle,
    this.helperText,
    this.content,
    this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (number != null) ListNumber(number),
          if (number != null) const Spacing(16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText('heading h5', title, alignment: TextAlign.left),
                  const Spacing(16),
                  if (subtitle != null) CustomText('text md', subtitle!, alignment: TextAlign.left),
                  if (subtitle != null) const Spacing(16),
                  if (helperText != null) CustomText('text sm text_secondary', helperText!, alignment: TextAlign.left),
                  if (helperText != null) const Spacing(16),
                  if (content != null) content!,
                  if (content != null) const Spacing(16),
                  if (buttons != null) CustomRow(buttons!, 10),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget ListNumber(number) {
    return Container(
      alignment: Alignment.center,
      height: 32,
      width: 32,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: ThemeColor.bgSecondary,
      ),
      child: CustomText('heading h6', number.toString()),
    );
  }
}

Widget aboutMeItem(BuildContext context, String aboutMe) {
  return DataItem(
    title: 'About me',
    content: CustomText('text md secondary', aboutMe, alignment: TextAlign.start),
  );
}

Widget addressItem(BuildContext context, String address) {
  copyAddress() async {
    HapticFeedback.heavyImpact();
    await Clipboard.setData(ClipboardData(text: address));
  }

  return DataItem(
    title: 'Bitcoin address',
    content: CustomText('text md secondary', address, alignment: TextAlign.start),
    buttons: [
      CustomButton('Copy', 'secondary md enabled hug copy', () => copyAddress()),
    ],
  );
}

Widget didItem(BuildContext context, String did) {
  copyAddress() async {
    HapticFeedback.heavyImpact();
    await Clipboard.setData(ClipboardData(text: did));
  }

  return DataItem(
    title: 'Digital ID',
    content: CustomText('text md secondary', did, alignment: TextAlign.start),
    buttons: [
      CustomButton('Copy', 'secondary md enabled hug copy', () => copyAddress()),
    ],
  );
}
