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

class GetTheApp extends StatefulWidget {
  final GlobalState globalState;
  const GetTheApp(this.globalState, {super.key});

  @override
  GetTheAppState createState() => GetTheAppState();
}

class GetTheAppState extends State<GetTheApp> {
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
        "Get the app",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/multi-device.png'),
            const Spacing(height: AppPadding.content),
            buildTextWithBrandMark(
              'The orange.me mobile app works with the desktop app to keep your friends and money safe.',
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
