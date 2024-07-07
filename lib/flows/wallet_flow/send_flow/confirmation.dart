import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/flows/wallet_flow/home.dart';
import 'package:orange/components/interfaces/default_interface.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_header.dart';
import 'package:orange/components/bumpers/single_button_bumper.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/util.dart';

class Confirmation extends StatefulWidget {
  final double amount;
  const Confirmation({super.key, required this.amount});

  @override
  ConfirmationState createState() => ConfirmationState();
}

class ConfirmationState extends State<Confirmation> {
  final TextEditingController recipientAddressController =
      TextEditingController();

  Widget build(BuildContext context) {
    return DefaultInterface(
      header: const StackHeader(
        text: "Confirm send",
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
            CustomText(
              text: "You sent \$${widget.amount}",
            ),
          ],
        ),
      ),
      bumper: SingleButton(
        variant: ButtonVariant.secondary,
        text: "Done",
        onTap: () => navigateTo(context, const WalletHome()),
      ),
    );
  }
}
