import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/result.dart';

import 'package:orange/flows/pairing/pair_desktop.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'dart:io' show Platform;

class Success extends StatefulWidget {
  final GlobalState globalState;
  const Success(this.globalState, {super.key});

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
        "Connection confirmed",
        exitButton(context, PairDesktop(widget.globalState)),
      ),
      content: Content(
        content: result(
          onDesktop
              ? 'This computer has been connected to your phone'
              : 'Your computer has been connected to this phone',
          ThemeIcon.checkmark,
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Done",
        () => {
          resetNavTo(
            context,
            PairDesktop(widget.globalState),
          ),
        },
        true,
        ButtonVariant.secondary,
      ),
    );
  }
}
