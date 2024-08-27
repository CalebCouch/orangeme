import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/paginator.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:loop_page_view/loop_page_view.dart';

import 'package:orange/flows/new_wallet/savings/setup_desktop.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'dart:io' show Platform;

class NewSavings extends StatefulWidget {
  final GlobalState globalState;

  const NewSavings(this.globalState, {super.key});

  @override
  NewSavingsState createState() => NewSavingsState();
}

class NewSavingsState extends State<NewSavings> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  int index = 0;

  Widget buildScreen(BuildContext context, DartState state) {
    LoopPageController controller = LoopPageController();
    return Interface(
      widget.globalState,
      header: stackHeader(
        context,
        "New savings wallet",
      ),
      content: Content(
        content: onDesktop
            ? Column(
                children: [
                  Flexible(
                    child: Image.asset(
                        'assets/images/mockups/mobile-new-savings.png'),
                  ),
                  buildTextWithBrandMark(
                    'To create a savings wallet open the orange.me app on your phone',
                    TextSize.h4,
                    FontWeight.w700,
                  ),
                ],
              )
            : LoopPageView.builder(
                onPageChanged: (page) => {
                  setState(() {
                    index = page;
                  })
                },
                controller: controller,
                itemCount: 4,
                itemBuilder: (_, index) {
                  return page(pages(index));
                },
              ),
      ),
      paginator: onDesktop ? null : paginator(index),
      bumper: onDesktop
          ? null
          : singleButtonBumper(context, "Continue", () {
              navigateTo(context, SetupDesktop(widget.globalState));
            }),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}

pages(int index) {
  switch (index) {
    case 0:
      return [
        'assets/images/mockups/multi-device.png',
        'Savings is a bitcoin wallet that stays protected even if your phone gets hacked',
      ];
    case 1:
      return [
        'assets/images/mockups/usb.png',
        'Setting up a savings wallet will create 1-3 USB security keys',
      ];
    case 2:
      return [
        'assets/images/mockups/messages.png',
        'Setting up a savings wallet will back up your friends list and accounts',
      ];
    case 3:
      return [
        'assets/images/mockups/desktop-wallet-home.png',
        'After setting up a savings wallet you can upgrade the security of your bitcoin spending wallets',
      ];
  }
}

Widget page(List<String> content) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Expanded(
        child: Center(
          child: Image.asset(content[0]),
        ),
      ),
      CustomText(
        text: content[1],
        textSize: TextSize.h4,
        textType: 'heading',
      ),
    ],
  );
}
