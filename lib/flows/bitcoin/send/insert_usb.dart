import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';

import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/classes.dart';

// DESKTOP ONLY

class InsertUSB extends StatefulWidget {
  final GlobalState globalState;
  final bool isConfirmationTakeover;
  const InsertUSB(
    this.globalState, {
    super.key,
    this.isConfirmationTakeover = false,
  });

  @override
  InsertUSBState createState() => InsertUSBState();
}

class InsertUSBState extends State<InsertUSB> {
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
        "Insert security key",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/usb.png'),
            const Spacing(height: AppPadding.content),
            const CustomText(
              text: 'Insert one of your USB security keys',
              textSize: TextSize.h4,
              textType: 'heading',
            ),
          ],
        ),
      ),
      navigationIndex: widget.isConfirmationTakeover ? null : 0,
      desktopOnly: true,
    );
  }
}
