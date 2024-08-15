import 'package:flutter/material.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/flows/bitcoin/new_wallet/spending/success.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';

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

  final TextEditingController controller =
      TextEditingController(text: "My Wallet 2");
  Widget buildScreen(BuildContext context, DartState state) {
    return Interface(
      widget.globalState,
      header: stackHeader(context, "New spending wallet"),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextInput(
              controller: controller,
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          navigateTo(context, Success(widget.globalState, controller.text));
        },
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
