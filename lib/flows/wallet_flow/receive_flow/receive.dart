import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/qr_code/qr_code.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_header.dart';
import 'package:orange/components/bumpers/single_button_bumper.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/components/interfaces/default_interface.dart';
import 'package:share/share.dart';

import 'package:orange/util.dart';

class Receive extends StatefulWidget {
  const Receive({
    super.key,
  });

  @override
  ReceiveState createState() => ReceiveState();
}

class ReceiveState extends State<Receive> {
  ValueNotifier<String> address = ValueNotifier("...");

  @override
  void initState() {
    getNewAddress();
    super.initState();
  }

  Future<void> getNewAddress() async {
    address.value = (await invoke("get_new_address", "")).data;
  }

  //used to bring up the OS native share window
  void onShare() {
    final String textToShare = address.value;
    Share.share(textToShare);
  }

  @override
  Widget build(BuildContext context) {
    currentCtx = context;
    return DefaultInterface(
      header: const StackHeader(text: "Receive bitcoin"),
      content: Content(
        content: Center(
          child: Column(
            children: [
              qrCode(address),
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
        onTap: () => onShare(),
      ),
    );
  }
}
