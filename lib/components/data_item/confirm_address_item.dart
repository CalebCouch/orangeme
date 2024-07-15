import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/data_item/data_item.dart';

import 'package:orange/flows/wallet_flow/send_flow/send.dart';

import 'package:orange/util.dart';

class ConfirmAddressItem extends StatelessWidget {
  const ConfirmAddressItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DataItem(
      title: "Confirm Address",
      listNum: 1,
      content: Container(
        child: const Column(
          children: [
            Spacing(height: AppPadding.bumper),
            CustomText(
                textSize: TextSize.md,
                alignment: TextAlign.left,
                text: "12FWmGPUCtFeZECFydRARUzfqt7h2GBqEL"),
            Spacing(height: AppPadding.bumper),
            CustomText(
              textSize: TextSize.sm,
              color: ThemeColor.textSecondary,
              alignment: TextAlign.left,
              text: "Bitcoin sent to the wrong address can never be recovered.",
            ),
            Spacing(height: AppPadding.bumper),
          ],
        ),
      ),
      buttonNames: const ["Address"],
      buttonActions: [
        () {
          navigateTo(context, const Send());
        }
      ],
    );
  }
}
