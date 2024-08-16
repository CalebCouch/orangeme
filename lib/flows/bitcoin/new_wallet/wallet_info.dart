import 'package:flutter/material.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/classes/test_classes.dart';
import 'dart:io' show Platform;

import 'package:orange/classes.dart';

class WalletInfo extends StatefulWidget {
  final GlobalState globalState;
  final Wallet thisWallet;
  const WalletInfo(this.globalState, this.thisWallet, {super.key});

  @override
  WalletInfoState createState() => WalletInfoState();
}

class WalletInfoState extends State<WalletInfo> {
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
      TextEditingController(text: 'Wallet');

  bool save = false;

  Widget buildScreen(BuildContext context, DartState state) {
    saveInfo() {
      setState(() {
        save = false;
      });
      FocusScope.of(context).requestFocus(FocusNode());
    }

    enableButton() {
      setState(() {
        save = true;
      });
    }

    return Interface(
      widget.globalState,
      header: stackHeader(context, "Settings"),
      content: Content(
        content: CustomTextInput(
          title: 'Wallet Name',
          onChanged: (String str) => {enableButton()},
          controller: controller,
        ),
      ),
      bumper: singleButtonBumper(
        context,
        'Save',
        save
            ? () {
                saveInfo();
              }
            : () {},
        save,
      ),
      desktopOnly: true,
      navigationIndex: 2,
    );
  }
}
