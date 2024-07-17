import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/default_interface.dart';

import 'package:orange/flows/wallet_flow/send_flow/send_amount.dart';
import 'package:orange/flows/wallet_flow/send_flow/scan_qr.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/tip_buttons.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class Send extends StatefulWidget {
  final GlobalState globalState;
  final String? address;
  const Send(this.globalState, {super.key, this.address});

  @override
  SendState createState() => SendState();
}

class SendState extends State<Send> {
  String setAddress = '';

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
    if (widget.address != null) setAddress = widget.address!;
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
              address: setAddress,
              error: isValidAddress(setAddress) ? "" : "Not a valid address",
              hint: 'Bitcoin address...',
            ),
            const Spacing(height: AppPadding.content),
            ButtonTip("Paste Clipboard", ThemeIcon.paste, () async {
              var data = (await getClipBoardData()).toString();
              setState(() => setAddress = data);
            }),
            const Spacing(height: AppPadding.tips),
            const CustomText(
              text: 'or',
              textSize: TextSize.sm,
              color: ThemeColor.textSecondary,
            ),
            const Spacing(height: AppPadding.tips),
            ButtonTip(
              "Scan QR Code",
              ThemeIcon.qrcode,
              () => switchPageTo(context, ScanQR(widget.globalState)),
            ),
            const Spacing(height: AppPadding.tips),
          ],
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          navigateTo(
            context,
            SendAmount(widget.globalState),
          );
        },
      ),
    );
  }
}
