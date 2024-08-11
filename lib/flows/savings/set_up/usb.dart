import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/savings/set_up/continue_mobile.dart';

import 'package:orange/util.dart';

class USB extends StatefulWidget {
  final GlobalState globalState;
  final int number;
  final bool toInsert;
  const USB(
    this.globalState, {
    super.key,
    required this.number,
    required this.toInsert,
  });

  @override
  State<USB> createState() => USBState();
}

class USBState extends State<USB> {
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
    String numStr = '';
    if (widget.number == 1) numStr = "first";
    if (widget.number == 2) numStr = "second";
    if (widget.number == 3) numStr = "third";
    return Interface(
      resizeToAvoidBottomInset: false,
      header: stackHeader(
        context,
        "Insert USB stick ${widget.number}\3",
      ),
      content: Content(
        content: Column(children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomIcon(
                  icon: ThemeIcon.usb,
                  iconSize: 128,
                ),
                Container(
                  padding: const EdgeInsets.all(AppPadding.placeholder),
                  child: CustomText(
                    text: 'Insert $numStr USB stick',
                    textType: 'heading',
                    textSize: TextSize.h3,
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
      //THIS SHOULD GET REMOVED
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          if (widget.number != 3 && widget.toInsert) {
            if (widget.toInsert) {
              navigateTo(
                context,
                USB(
                  widget.globalState,
                  number: widget.number + 1,
                  toInsert: !widget.toInsert,
                ),
              );
            }
          }
          navigateTo(context, ContinueMobile(widget.globalState));
        },
      ),
    );
  }
}
