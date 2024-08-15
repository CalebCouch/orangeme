import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';

import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/scan_qr.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/tip_buttons.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class Send extends StatefulWidget {
  final GlobalState globalState;
  final String? address;
  const Send(this.globalState, {super.key, this.address});

  @override
  SendState createState() => SendState();
}

class SendState extends State<Send> {
  String addressStr = '';
  bool addressValid = false;

  Future<void> setAddress(String address) async {
    var valid =
        (await widget.globalState.invoke("check_address", address)).data ==
            "true";
    setState(() {
      addressStr = address;
      addressValid = valid;
    });
  }

  @override
  initState() {
    setAddress(widget.address ?? "");
    super.initState();
  }

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
      header: stackHeader(context, "Bitcoin address", true),
      content: Content(
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextInput(
                presetTxt: addressStr,
                onChanged: (String address) => {setAddress(address)},
                error: addressValid || addressStr.isEmpty
                    ? ""
                    : "Not a valid address",
                hint: 'Bitcoin address...',
              ),
              const Spacing(height: AppPadding.content),
              ButtonTip("Paste Clipboard", ThemeIcon.paste, () async {
                String data = (await getClipBoardData()).toString();
                if (data != "null") {
                  setAddress(data);
                }
              }),
              const Spacing(height: AppPadding.tips),
              const CustomText(
                text: 'or',
                textSize: TextSize.sm,
                color: ThemeColor.textSecondary,
              ),
              const Spacing(height: AppPadding.tips),
              ButtonTip(
                "Scan QR Code",
                ThemeIcon.qrcode,
                () => navigateTo(context, ScanQR(widget.globalState)),
              ),
              const Spacing(height: AppPadding.tips),
            ],
          ),
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          navigateTo(context, SendAmount(widget.globalState, addressStr));
        },
        addressValid,
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
