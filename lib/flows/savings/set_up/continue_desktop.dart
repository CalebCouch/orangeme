import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/savings/set_up/transfer_funds.dart';

import 'package:orange/util.dart';

class ContinueDesktop extends StatefulWidget {
  final GlobalState globalState;
  const ContinueDesktop(this.globalState, {super.key});

  @override
  State<ContinueDesktop> createState() => ContinueDesktopState();
}

class ContinueDesktopState extends State<ContinueDesktop> {
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
        "Continue set up",
      ),
      content: Content(
        content: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomIcon(
                icon: ThemeIcon.monitor,
                iconSize: 128,
              ),
              Container(
                padding: const EdgeInsets.all(AppPadding.placeholder),
                child: const CustomText(
                  text: 'Continue set up on your laptop or desktop computer',
                  textType: 'heading',
                  textSize: TextSize.h5,
                ),
              ),
            ],
          ),
        ),
      ),
      //remove this
      //user needs to be automatically sent to the next page
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          navigateTo(context, TransferFunds(widget.globalState));
        },
      ),
    );
  }
}
