import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/savings/set_up/completed.dart';

import 'package:orange/util.dart';

class ContinueMobile extends StatefulWidget {
  final GlobalState globalState;
  const ContinueMobile(this.globalState, {super.key});

  @override
  State<ContinueMobile> createState() => ContinueMobileState();
}

class ContinueMobileState extends State<ContinueMobile> {
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
    return Interface(
      resizeToAvoidBottomInset: false,
      header: stackHeader(
        context,
        "Continue set up",
      ),
      content: Content(
        scrollable: false,
        content: Expanded(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(AppPadding.placeholder),
              child: const CustomText(
                text: 'Continue set up on your phone',
                textType: 'heading',
                textSize: TextSize.h5,
              ),
            ),
          ),
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          navigateTo(context, CompletedSetUp(widget.globalState));
        },
      ),
    );
  }
}
