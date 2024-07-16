import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/default_interface.dart';

import 'package:orange/flows/wallet_flow/send_flow/send_amount.dart';
import 'package:orange/flows/wallet_flow/send_flow/choose_send_recipient.dart';
import 'package:orange/flows/wallet_flow/send_flow/scan_qr.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/tip_buttons.dart';
import 'package:orange/util.dart';

class Send extends StatefulWidget {
  const Send({super.key});

  @override
  SendState createState() => SendState();
}

class SendState extends State<Send> {
  final TextEditingController recipientAddressController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultInterface(
      header: stackHeader(
        context,
        "Bitcoin address",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextInput(
              controller: recipientAddressController,
              hint: 'Bitcoin address...',
            ),
            threeTips([
              ButtonTip("pn1Th...a02Cr", ThemeIcon.paste, () {}),
              ButtonTip(
                "Scan QR Code",
                ThemeIcon.qrcode,
                () => navigateTo(context, const ScanQR()),
              ),
              ButtonTip(
                "Select Contact",
                ThemeIcon.profile,
                () => navigateTo(context, const ChooseSendRecipient()),
              ),
            ]),
          ],
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          navigateTo(
            context,
            const SendAmount(),
          );
        },
      ),
    );
  }
}
