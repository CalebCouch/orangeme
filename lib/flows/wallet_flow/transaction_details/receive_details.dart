import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_header.dart';
import 'package:orange/components/bumpers/single_button_bumper.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/amount_display/amount_display.dart';

import 'package:orange/interfaces/default_interface.dart';

class ReceiveDetails extends StatefulWidget {
  final List<dynamic> transactionDetails;
  const ReceiveDetails({super.key, required this.transactionDetails});

  @override
  ReceiveDetailsState createState() => ReceiveDetailsState();
}

class ReceiveDetailsState extends State<ReceiveDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultInterface(
      header: const StackHeader(text: "Received bitcoin"),
      content: Content(
        content: Column(
          children: [
            AmountDisplay(value: widget.transactionDetails[0]),
          ],
        ),
      ),
      bumper: SingleButton(
        variant: ButtonVariant.secondary,
        text: "Done",
        onTap: () {},
      ),
    );
  }
}
