import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_text.dart';

class Confirmation extends StatefulWidget {
  final double amount;
  final String? recipient;
  const Confirmation({super.key, required this.amount, this.recipient});

  @override
  ConfirmationState createState() => ConfirmationState();
}

class ConfirmationState extends State<Confirmation> {
  final TextEditingController recipientAddressController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultInterface(
      header: stackHeader(
        context,
        "Confirm send",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomIcon(
              icon: ThemeIcon.success,
              iconColor: ThemeColor.bitcoin,
              iconSize: 128,
            ),
            const Spacing(height: AppPadding.bumper),
            widget.recipient != null
                ? CustomText(
                    text: "You sent \$${widget.amount} to\n${widget.recipient}",
                    textType: 'heading',
                  )
                : CustomText(
                    text: "You sent \$${widget.amount}",
                    textType: 'heading',
                  ),
          ],
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Done",
        () => {}, //resetNavTo(context, const WalletHome()),
        true,
        ButtonVariant.secondary,
      ),
    );
  }
}