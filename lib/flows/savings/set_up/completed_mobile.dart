import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/flows/savings/home.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class CompletedMobile extends StatefulWidget {
  final GlobalState globalState;
  const CompletedMobile(this.globalState, {super.key});

  @override
  CompletedMobileState createState() => CompletedMobileState();
}

class CompletedMobileState extends State<CompletedMobile> {
  final TextEditingController recipientAddressController =
      TextEditingController();

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
      header: stackHeader(
        context,
        "Set up complete",
        exitButton(context, SavingsHome(widget.globalState)),
      ),
      content: const Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIcon(
              icon: ThemeIcon.savings,
              iconSize: 128,
            ),
            Spacing(height: AppPadding.bumper),
            CustomText(
              text: "Your savings account has\n been successfully created",
              textType: 'heading',
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Done",
        () => {
          resetNavTo(
            context,
            SavingsHome(widget.globalState),
          ),
        },
        true,
        ButtonVariant.secondary,
      ),
    );
  }
}
