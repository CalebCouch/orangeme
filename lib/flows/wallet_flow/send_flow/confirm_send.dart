import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/interfaces/default_interface.dart';
import 'package:orange/flows/wallet_flow/send_flow/confirmation.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_header.dart';
import 'package:orange/components/bumpers/single_button_bumper.dart';
import 'package:orange/components/data_item/confirm_address_item.dart';
import 'package:orange/components/data_item/confirm_amount_item.dart';
import 'package:orange/components/data_item/confirm_recipient_item.dart';
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
      header: const StackHeader(
        text: "Confirm send",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.recipient == null
                ? const ConfirmAddressItem()
                : ConfirmRecipientItem(
                    recipient: widget.recipient,
                  ),
            const Spacing(height: AppPadding.bumper),
            const ConfirmAmountItem(),
          ],
        ),
      ),
      bumper: SingleButton(
        text: "Confirm & Send",
        onTap: () {
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
