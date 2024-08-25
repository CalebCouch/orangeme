import 'package:flutter/material.dart';

import 'package:orange/components/header.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/flows/new_wallet/savings/continue_desktop.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class NameWallet extends StatefulWidget {
  final GlobalState globalState;
  const NameWallet(
    this.globalState, {
    super.key,
  });

  @override
  NameWalletState createState() => NameWalletState();
}

class NameWalletState extends State<NameWallet> {
  late TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool canContinue = true;

  Widget build_screen(BuildContext context, DartState state) {
    next() {
      setState(() {
        canContinue = false;
        navigateTo(context, ContinueDesktop(widget.globalState));
      });
      FocusScope.of(context).requestFocus(FocusNode());
    }

    enableButton() {
      setState(() {
        canContinue = true;
      });
    }

    controller = TextEditingController(text: 'My Savings');

    return Interface(
      widget.globalState,
      header: stackHeader(context, "Name wallet"),
      content: Content(
        content: Column(
          children: [
            CustomTextInput(
              title: 'Wallet Name',
              hint: 'Wallet name...',
              onChanged: (String str) => {enableButton()},
              controller: controller,
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(
        context,
        'Continue',
        canContinue
            ? () {
                next();
              }
            : () {},
        canContinue,
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
