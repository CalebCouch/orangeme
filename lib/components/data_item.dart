import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orangeme_material/orangeme_material.dart';

class DataItem extends StatelessWidget {
  final String title;
  final dynamic content;
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (number != null) ListNumber(number),
        if (number != null) const Spacing(16),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: CustomColumn([
            CustomText('heading h5', title),
            if (subtitle != null) CustomText('text md', subtitle!),
            if (helperText != null) CustomText('text sm text_secondary', helperText!),
            content,
            if (buttons != null) CustomRow(buttons!, 10)
          ], 16, true, false),
        )
      ],
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
    content: CustomText('text md secondary', aboutMe),
  );
}

Widget addressItem(BuildContext context, String address) {
  copyAddress() async {
    HapticFeedback.heavyImpact();
    await Clipboard.setData(ClipboardData(text: address));
  }

  return DataItem(
    title: 'Bitcoin address',
    content: CustomText('text md secondary', address),
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
    content: CustomText('text md secondary', did),
    buttons: [
      CustomButton('Copy', 'secondary md enabled hug copy', () => copyAddress()),
    ],
  );
}
