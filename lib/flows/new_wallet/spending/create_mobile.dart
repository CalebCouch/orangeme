import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class CreateMobileSpending extends StatefulWidget {
  final GlobalState globalState;
  const CreateMobileSpending(this.globalState, {super.key});

  @override
  CMSState createState() => CMSState();
}

class CMSState extends State<CreateMobileSpending> {
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
        "New spending wallet",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/wallet-home.png'),
            const Spacing(height: AppPadding.content),
            buildTextWithBrandMark(
              'To create a spending wallet open the orange.me app on your phone',
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
