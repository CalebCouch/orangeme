import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/flows/wallet_flow/send_flow/confirmation.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/util.dart';

class ConfirmSend extends StatefulWidget {
  final String recipient;
  const ConfirmSend({
    super.key,
    this.recipient = 'Chris Slaughter',
  });

  @override
  ConfirmState createState() => ConfirmState();
}

class ConfirmState extends State<ConfirmSend> {
  final TextEditingController recipientAddressController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultInterface(
      header: stackHeader(
        context,
        'Confirm send',
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.recipient == null
                ? confirmAddressItem(context, 'at39Oh1dKOrTSla18eaBlaKBR94krl')
                : confirmRecipientItem(context, widget.recipient,
                    'axkcarl8k9oExROL10HTbo01Brsalt'),
            const Spacing(height: AppPadding.bumper),
            confirmAmountItem(
              context,
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Confirm & Send",
        () {
          navigateTo(
            context,
            const Confirmation(
              amount: 45.32,
              recipient: 'Chris Slaughter',
            ),
          );
        },
      ),
    );
  }
}
