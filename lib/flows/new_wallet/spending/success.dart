import 'package:flutter/material.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/result.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'dart:io' show Platform;

class Success extends StatefulWidget {
  final GlobalState globalState;
  final String walletName;
  const Success(this.globalState, this.walletName, {super.key});

  @override
  SuccessState createState() => SuccessState();
}

class SuccessState extends State<Success> {
  bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
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
    return Interface(
      widget.globalState,
      header: stackHeader(
        context,
        "Wallet created",
        exitButton(context, MultiWalletHome(widget.globalState, wallets: [])),
      ),
      content: Content(
        content: result(
          '${widget.walletName} has been successfully created',
          ThemeIcon.wallet,
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Done",
        () => {
          resetNavTo(
            context,
            MultiWalletHome(widget.globalState, wallets: []),
          ),
        },
        true,
        ButtonVariant.secondary,
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
