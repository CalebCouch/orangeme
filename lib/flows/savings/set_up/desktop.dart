import 'package:flutter/material.dart';
import 'package:orange/classes.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/placeholder.dart';
import 'package:orange/flows/savings/set_up/requirements.dart';

import 'package:orange/util.dart';

class DesktopSetUp extends StatefulWidget {
  final GlobalState globalState;
  const DesktopSetUp(this.globalState, {super.key});

  @override
  State<DesktopSetUp> createState() => DesktopSetUpState();
}

class DesktopSetUpState extends State<DesktopSetUp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  Widget build_screen(BuildContext context, DartState state) {
    return DefaultInterface(
      resizeToAvoidBottomInset: false,
      header: stackHeader(
        context,
        "Savings",
      ),
      content: Content(
        content: Column(children: [
          const CustomBanner(
            message:
                'You will need to wait an hour\nafter set up to spend your bitcoin',
            isDismissable: false,
          ),
          placeholder(
            context,
            "Install the orange.me desktop app on your laptop or desktop computer by inputing the following URL in your browser\n\ndesktop.orange.me",
            true,
          ),
        ]),
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          navigateTo(context, Requirements(widget.globalState));
        },
      ),
    );
  }
}
