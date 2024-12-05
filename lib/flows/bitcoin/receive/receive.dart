import 'package:flutter/material.dart';
import 'package:orange/components/qr_code/qr_code.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:share_plus/share_plus.dart';
import 'package:orange/generic.dart';

class Receive extends GenericWidget {
    Receive({super.key});

    String address = "";
    
    @override
    ReceiveState createState() => ReceiveState();
}

class ReceiveState extends GenericState<Receive> {

    @override
    PageName getPageName() {
        return PageName.receive();
    }

    @override
    int refreshInterval() {
        return 0;
    }

    @override
    unpack_state(Map<String, dynamic> json) {
        widget.address = json["address"];
    }

    @override
    void initState() {
        super.initState();
    }

    onShare() => Share.share("Send me Bitcoin:\n${widget.address}");

    @override
    Widget build_with_state(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Receive bitcoin"),
            content: [
                QRCode(widget.address),
                Instructions(),
            ],
            bumper: Bumper(context, 
                content: [CustomButton(txt: 'Share', variant: 'primary', size: 'lg', onTap: onShare)]
            ),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}
