import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class ContinueDesktop extends StatefulWidget {
  final GlobalState globalState;

  const ContinueDesktop(this.globalState, {super.key});

  @override
  ContinueDesktopState createState() => ContinueDesktopState();
}

class ContinueDesktopState extends State<ContinueDesktop> {
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
        "Continue on desktop",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/desktop-wallet-home.png'),
            const Spacing(height: AppPadding.content),
            buildTextWithBrandMark(
              'Continue on the orange.me desktop app on your laptop or desktop computer',
              TextSize.h4,
              FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}
