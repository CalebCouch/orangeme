import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/flows/pairing/download_desktop.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class ConnectStart extends StatefulWidget {
  final GlobalState globalState;

  const ConnectStart(this.globalState, {super.key});

  @override
  ConnectStartState createState() => ConnectStartState();
}

class ConnectStartState extends State<ConnectStart> {
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
        "Connect to a computer",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/multi-device.png'),
            buildTextWithBrandMark(
              'Connect your phone to the orange.me desktop app on your laptop or desktop computer',
              TextSize.h4,
              FontWeight.w700,
            )
          ],
        ),
      ),
      bumper: singleButtonBumper(context, "Continue", () {
        navigateTo(context, DownloadDesktop(widget.globalState));
      }),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
