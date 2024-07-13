import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/data_item/data_item.dart';

class AboutMeItem extends StatelessWidget {
  final String aboutMe;
  const AboutMeItem({
    required this.aboutMe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
}
