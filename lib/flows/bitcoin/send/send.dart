import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:orange/flows/bitcoin/wallet.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/scan_qr.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/interface.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/custom/custom_icon.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

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

  /* Validates the Bitcoin address by invoking a backend check. */
  Future<void> checkAddress(String address) async {
    if (address.contains('bitcoin:')) address = address.substring(8);
    var valid =
        (await widget.globalState.invoke("check_address", address)).data ==
            "true";
    setState(() {
      addressValid = valid;
    });
  }

  /* Updates the address and its validity, also sets the address in the text controller. */
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
      header: stackHeader(
        context,
        "Bitcoin address",
        iconButton(
          context,
          () {
            resetNavTo(context, WalletHome(widget.globalState));
          },
          const CustomIcon(iconSize: IconSize.md, icon: ThemeIcon.left),
        ),
      ),
      content: Content(
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextInput(
                controller: controller,
                onSubmitted: (String address) => {setAddress(address)},
                onChanged: (String address) => {checkAddress(address)},
                error: addressValid || addressStr.isEmpty
                    ? ""
                    : "Not a valid address",
                hint: 'Bitcoin address...',
              ),
              const Spacing(height: AppPadding.content),
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
          checkAddress(controller.text);
          if (addressValid) {
            navigateTo(
                context, SendAmount(widget.globalState, controller.text));
          }
        },
        addressValid,
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
