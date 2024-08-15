import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class Success extends StatefulWidget {
  final String walletName;
  final GlobalState globalState;
  const Success(this.globalState, this.walletName, {super.key});

  @override
  SuccessState createState() => SuccessState();
}

class SuccessState extends State<Success> {
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
        "Wallet created",
        exitButton(context, BitcoinHome(widget.globalState)),
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomIcon(
              icon: ThemeIcon.wallet,
              iconColor: ThemeColor.secondary,
              iconSize: 128,
            ),
            const Spacing(height: AppPadding.bumper),
            CustomText(
              text: "${widget.walletName} has been successfully created",
              textType: 'heading',
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Done",
        () => {
          resetNavTo(context, BitcoinHome(widget.globalState)),
        },
        true,
        ButtonVariant.secondary,
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
