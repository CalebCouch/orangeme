import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';

import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/scan_qr.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/tip_buttons.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class NewWallet extends StatefulWidget {
  final GlobalState globalState;
  final String? address;
  const NewWallet(this.globalState, {super.key, this.address});

  @override
  NewWalletState createState() => NewWalletState();
}

class NewWalletState extends State<NewWallet> {
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
    return Interface(
      widget.globalState,
      header: stackHeader(context, "New spending wallet"),
      content: const Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextInput(
              presetTxt: "My Wallet 2",
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          //navigateTo(context, SendAmount(widget.globalState, addressStr));
        },
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
