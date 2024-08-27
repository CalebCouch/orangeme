import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/flows/pairing/download_mobile.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

// DESKTOP ONLY

class ConnectPhone extends StatefulWidget {
  final GlobalState globalState;
  const ConnectPhone(this.globalState, {super.key});

  @override
  ConnectPhoneState createState() => ConnectPhoneState();
}

class ConnectPhoneState extends State<ConnectPhone> {
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
        "Connect phone",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/wallet-home.png', width: 200),
            const Spacing(height: AppPadding.content),
            buildTextWithBrandMark(
              'On the orange.me app, press Connect to a Computer',
              TextSize.h3,
              FontWeight.w700,
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(context, "Continue", () {
        navigateTo(context, DownloadMobile(widget.globalState));
      }),
    );
  }
}
