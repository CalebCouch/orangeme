import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/data_item/data_item.dart';

import 'package:flutter/services.dart';

class DidItem extends StatelessWidget {
  final String did;
  const DidItem({
    required this.did,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
}
