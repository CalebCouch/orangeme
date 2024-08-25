import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class Requirements extends StatefulWidget {
  final GlobalState globalState;
  const Requirements(this.globalState, {super.key});

  @override
  RequirementsState createState() => RequirementsState();
}

class RequirementsState extends State<Requirements> {
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
        "New savings wallet",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/mobile-new-savings.png'),
            const Spacing(height: AppPadding.content),
            buildTextWithBrandMark(
              'To create a savings wallet open the orange.me app on your phone',
              TextSize.h3,
              FontWeight.w700,
            )
          ],
        ),
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
