import 'package:flutter/material.dart';

import 'package:orange/components/header.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/flows/new_wallet/savings/success.dart';

import 'package:orange/classes.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/util.dart';
import 'dart:io' show Platform;

class NewSpending extends StatefulWidget {
  final GlobalState globalState;
  final int walletCount;
  const NewSpending(
    this.globalState,
    this.walletCount, {
    super.key,
  });

  @override
  NewSpendingState createState() => NewSpendingState();
}

class NewSpendingState extends State<NewSpending> {
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
        navigateTo(context, Success(widget.globalState, controller.text));
      });
      FocusScope.of(context).requestFocus(FocusNode());
    }

    enableButton() {
      setState(() {
        canContinue = true;
      });
    }

    bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;

    controller =
        TextEditingController(text: 'My Wallet ${widget.walletCount + 1}');

    return Interface(
      widget.globalState,
      header: stackHeader(context, "New spending wallet"),
      content: Content(
        content: onDesktop
            ? Column(
                children: [
                  Flexible(
                    child: Image.asset('assets/images/mockups/wallet-home.png'),
                  ),
                  buildTextWithBrandMark(
                    'To create a spending wallet open the orange.me app on your phone',
                    TextSize.h4,
                    FontWeight.w700,
                  ),
                ],
              )
            : Column(
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
      bumper: onDesktop
          ? null
          : singleButtonBumper(
              context,
              'Confirm & Create',
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
