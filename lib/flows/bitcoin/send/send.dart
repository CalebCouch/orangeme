import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/scan_qr.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/tip_buttons.dart';
import 'package:orange/components/interface.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orange/theme/stylesheet.dart';

// BITCOIN SEND STEP ONE //

// This page allows users to input a Bitcoin address, validate it, and proceed
// to send Bitcoin. It supports manual entry, pasting from clipboard,
// and scanning QR codes.

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

  //This function checks the address validity and sets the input field
  Future<void> setAddress(String address) async {
    if (address.contains('bitcoin:')) address = address.substring(8);
    var valid =
        (await widget.globalState.invoke("check_address", address)).data ==
            "true";
    setState(() {
      addressStr = address;
      addressValid = valid;
      controller.text = addressStr;
    });
  }

  //This function only checks the address validity
  Future<void> checkAddress(String address) async {
    if (address.contains('bitcoin:')) address = address.substring(8);
    var valid =
        (await widget.globalState.invoke("check_address", address)).data ==
            "true";
    setState(() {
      addressValid = valid;
    });
  }

  onContinue() {
    checkAddress(controller.text);
    if (addressValid) {
      navigateTo(context, SendAmount(widget.globalState, controller.text));
    }
  }

  @override
  initState() {
    controller.text = addressStr;
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

  final TextEditingController controller = TextEditingController();

  Widget buildScreen(BuildContext context, DartState state) {
    return Interface(
      widget.globalState,
      header: stackHeader(context, "Bitcoin address", backButton(context)),
      content: Content(
        children: [
          addressInput(
            controller,
            addressValid,
            addressStr,
            setAddress,
            checkAddress,
          ),
          buttonTips(context, widget.globalState, setAddress)
        ],
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        onContinue,
        addressValid,
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}

Widget addressInput(controller, bool addressValid, String addressStr,
    setAddress, checkAddress) {
  return CustomTextInput(
    controller: controller,
    onSubmitted: (String address) => {setAddress(address)},
    onChanged: (String address) => {checkAddress(address)},
    error: addressValid || addressStr.isEmpty ? "" : "Not a valid address",
    hint: 'Bitcoin address...',
  );
}

Widget buttonTips(BuildContext context, GlobalState globalState, setAddress) {
  return Column(
    children: [
      ButtonTip("Paste Clipboard", ThemeIcon.paste, () async {
        HapticFeedback.heavyImpact();
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
        () => navigateTo(context, ScanQR(globalState)),
      ),
    ],
  );
}
