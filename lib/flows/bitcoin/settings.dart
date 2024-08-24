import 'package:flutter/material.dart';

import 'package:orange/components/header.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/classes.dart';
import 'package:orange/temp_classes.dart';

// Settings for a wallet. Currently only allows the user to rename their wallet.

class Settings extends StatefulWidget {
  final GlobalState globalState;
  final Wallet wallet;
  const Settings(
    this.globalState, {
    super.key,
    required this.wallet,
  });

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
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

  bool save = false;

  Widget build_screen(BuildContext context, DartState state) {
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

    controller = TextEditingController(text: widget.wallet.name);

    return Interface(
      widget.globalState,
      header: stackHeader(context, "Group members"),
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
        'Save',
        save
            ? () {
                saveInfo();
              }
            : () {},
        save,
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
