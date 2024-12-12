import 'package:flow_bitcoin/flow_bitcoin.dart';

import 'package:material/material.dart';

import 'package:orange/qr_code/qr_code.dart';
import 'package:share_plus/share_plus.dart';

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
                CustomText(variant: 'text', font_size: 'md', text_color: 'text_secondary', txt: 'Scan to receive bitcoin.'),
            ],
            bumper: Bumper(context, 
                content: [CustomButton(txt: 'Share', variant: 'primary', size: 'lg', onTap: onShare)]
            ),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}