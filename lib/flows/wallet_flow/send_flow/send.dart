import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_button.dart';

import 'package:orange/interfaces/default_interface.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_header.dart';
import 'package:orange/components/text_input/text_input.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/theme/stylesheet.dart';

class Send extends StatefulWidget {
  const Send({super.key});

  _enterReceiveFlow() {}
  _enterSendFlow() {}

  @override
  SendState createState() => SendState();
}

class SendState extends State<Send> {
  final TextEditingController recipientAddressController =
      TextEditingController();

  Widget build(BuildContext context) {
    return DefaultInterface(
      header: const StackHeader(
        text: "Bitcoin address",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextInput(
              controller: recipientAddressController,
              hint: 'Bitcoin address...',
            ),
            const CustomButton(
              buttonSize: ButtonSize.md,
              expand: false,
              variant: ButtonVariant.secondary,
              text: "pn1ThS2aa02Cr...",
              icon: ThemeIcon.paste,
              onTap: null,
            ),
            const CustomText(
              text: "or",
              textSize: TextSize.sm,
              color: ThemeColor.textSecondary,
            ),
            const CustomButton(
              buttonSize: ButtonSize.md,
              expand: false,
              variant: ButtonVariant.secondary,
              text: "Scan QR Code",
              icon: ThemeIcon.qrcode,
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }
}
