import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/data_item/data_item.dart';

import 'package:flutter/services.dart';

class AddressItem extends StatelessWidget {
  final String address;
  const AddressItem({
    required this.address,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
}
