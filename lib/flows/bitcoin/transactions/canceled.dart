import 'package:flutter/material.dart';

import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/result.dart';

import 'package:orange/flows/bitcoin/wallet.dart';

import 'package:orange/classes.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/util.dart';

class Canceled extends StatefulWidget {
  final GlobalState globalState;
  const Canceled(this.globalState, {super.key});

  @override
  CanceledState createState() => CanceledState();
}

class CanceledState extends State<Canceled> {
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
        "Send canceled",
        exitButton(context, WalletHome(widget.globalState)),
      ),
      content: Content(
        content: result('Bitcoin send canceled', ThemeIcon.cancel),
      ),
      bumper: singleButtonBumper(
        context,
        "Done",
        () => {
          resetNavTo(
            context,
            WalletHome(widget.globalState),
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
