import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:flutter/services.dart';

import 'package:orange/components/qr_code/qr_code.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/components/interface.dart';

import 'package:share/share.dart';
import 'package:orange/global.dart' as global;

import 'package:orange/flows/bitcoin/home.dart';

// The Receive widget provides an interface for users to receive Bitcoin by
// displaying a QR code and address. It supports both desktop and mobile 
// platforms, allowing users to either copy the address or share it via different
// methods depending on the platform.
class Receive extends StatefulWidget {
    Receive({super.key});

    String address = "";

    @override
    ReceiveState createState() => ReceiveState();
}

class ReceiveState extends State<Receive> {
    @override
    void initState() {
        super.initState();
        _asyncInitState();
    }
    _asyncInitState() async {
        var address = await global.invoke("get_new_address", "");
        setState(() {
            widget.address = address;
        });
    }

    @override
    Widget build(BuildContext context) {
        return Interface(
            header: stackHeader(BitcoinHome(), "Receive bitcoin"),
            content: Content(
              content: Column(
                mainAxisAlignment:
                    global.platform_isDesktop ? MainAxisAlignment.center : MainAxisAlignment.start,
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
            bumper: global.platform_isDesktop
                ? singleButtonBumper(
                    context,
                    "Copy Address",
                    () async {
                      await Clipboard.setData(ClipboardData(text: widget.address));
                    },
                  )
                : singleButtonBumper(
                    context,
                    "Share",
                    () => {Share.share(widget.address)},
                  ),
            desktopOnly: true,
            navigationIndex: 0,
        );
    }
}
