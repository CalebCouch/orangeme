import 'package:flutter/material.dart';
import 'package:orange/components/buttons/icon_text_button.dart';

import 'package:orange/interfaces/default_interface.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_header.dart';
import 'package:orange/components/text_input/text_input.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/theme/stylesheet.dart';

class Send extends StatefulWidget {
  const Send({super.key});

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
            IconTextButton(
              text: "pn1ThS2aa02Cr...",
              icon: ThemeIcon.paste,
              onTap: () {},
            ),
            const Spacing(height: AppPadding.tips),
            const CustomText(
              text: "or",
              textSize: TextSize.sm,
              color: ThemeColor.textSecondary,
            ),
            const Spacing(height: AppPadding.tips),
            IconTextButton(
              text: "Scan QR Code",
              icon: ThemeIcon.qrcode,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
