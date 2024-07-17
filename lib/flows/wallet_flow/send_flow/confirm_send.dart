import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/flows/wallet_flow/send_flow/confirmation.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class ConfirmSend extends StatefulWidget {
  final String? recipient;
  final GlobalState globalState;
  const ConfirmSend(
    this.globalState, {
    super.key,
    this.recipient,
  });

  @override
  ConfirmState createState() => ConfirmState();
}

class ConfirmState extends State<ConfirmSend> {
  final TextEditingController recipientAddressController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  Widget buildScreen(BuildContext context, DartState state) {
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
                ? confirmAddressItem(widget.globalState, context,
                    'at39Oh1dKOrTSla18eaBlaKBR94krl')
                : confirmRecipientItem(widget.globalState, context,
                    widget.recipient!, 'axkcarl8k9oExROL10HTbo01Brsalt'),
            const Spacing(height: AppPadding.bumper),
            confirmAmountItem(widget.globalState, context, true),
          ],
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Confirm & Send",
        () {
          navigateTo(
            context,
            Confirmation(
              widget.globalState,
              amount: 45.32,
              recipient: 'Chris Slaughter',
            ),
          );
        },
      ),
    );
  }
}
