import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/data_item/data_item.dart';

import 'package:orange/components/tabular/contact_tabular.dart';
import 'package:orange/util.dart';
import 'package:orange/flows/wallet_flow/send_flow/send.dart';

class ConfirmRecipientItem extends StatelessWidget {
  final String recipient;
  final String did;

  const ConfirmRecipientItem({
    super.key,
    this.recipient = 'Chris Slaughter',
    this.did = '12FWmGP...qt7h2GBqEL',
  });

  @override
  Widget build(BuildContext context) {
    return DataItem(
      title: "Confirm contact",
      listNum: 1,
      content: Container(
        child: Column(
          children: [
            const Spacing(height: AppPadding.bumper),
            ContactTabular(
              name: recipient,
              did: did,
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
      ),
      buttonNames: const ["Recipient"],
      buttonActions: [
        () {
          navigateTo(context, const Send());
        }
      ],
    );
  }
}
