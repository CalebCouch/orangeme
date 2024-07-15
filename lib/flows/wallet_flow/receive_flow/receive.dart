import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/qr_code/qr_code.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_header.dart';
import 'package:orange/components/bumpers/single_button_bumper.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/components/interfaces/default_interface.dart';
import 'package:share/share.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class Receive extends StatefulWidget {
  final GlobalState globalState;
  final String address;
  const Receive(
    this.globalState,
    this.address,
    {super.key}
  );

  @override
  ReceiveState createState() => ReceiveState();
}

class ReceiveState extends State<Receive> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child){
        print("rebuild");
        return build_screen(context, state);
      }
    );
  }

  Widget build_screen(BuildContext context, DartState state) {
    return DefaultInterface(
      header: const StackHeader(text: "Receive bitcoin"),
      content: Content(
        content: Center(
          child: Column(
            children: [
              qrCode(widget.address),
              const Spacing(height: AppPadding.content),
              const CustomText(
                text: 'Scan to receive bitcoin.',
                textType: "text",
                color: ThemeColor.textSecondary,
                textSize: TextSize.md,
              )
            ],
          ),
        ),
      ),
      bumper: SingleButton(
        text: "Share",
        onTap: () => {Share.share(widget.address)}
      ),
    );
  }
}
