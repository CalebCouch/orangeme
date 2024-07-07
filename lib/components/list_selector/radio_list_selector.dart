import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_icon.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/theme/stylesheet.dart';

class RadioListSelector extends StatefulWidget {
  final String title;
  final String subtitle;
  final String icon;

  const RadioListSelector(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon});
  @override
  State<RadioListSelector> createState() => _ListSelectorState();
}

class _ListSelectorState extends State<RadioListSelector> {
  @override
  Widget build(BuildContext context) {
    //Widget customRadioButton(String title, String subtitle, int index) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomIcon(icon: widget.icon, iconSize: IconSize.md),
          const Spacing(width: AppPadding.bumper),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  textType: 'heading',
                  alignment: TextAlign.left,
                  text: widget.title,
                  textSize: TextSize.h5,
                ),
                const Spacing(height: 8),
                CustomText(
                  alignment: TextAlign.left,
                  text: widget.subtitle,
                  textSize: TextSize.sm,
                  color: ThemeColor.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
