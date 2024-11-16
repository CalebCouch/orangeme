import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/scan_qr.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';


class Send extends GenericWidget {
    Send({super.key});

    bool addressValid = true;

    @override
    SendState createState() => SendState();
}

class SendState extends GenericState<Send> {
    TextEditingController controller = TextEditingController();
    String address = '';

    @override
    PageName getPageName() {
        return PageName.send(address);
    }

    @override
    int refreshInterval() {
        return 80;
    }

    @override
    void unpack_state(Map<String, dynamic> json) {
        setState(() {
            widget.addressValid = json["valid_address"] as bool;
        });
    }

    onContinue() {
        navigateTo(context, Amount(address));
    }

    @override
    void initState() {
        super.initState();
        controller.text = address;
    }

    onPaste() async {
        ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
        if (data != null) {controller.text = data.text!;}
        address = controller.text;
    }

    Future<void> onScan() async {
        String scannedQR = await navigateToReturn(context, ScanQR());
        if (scannedQR != null) { 
            setState(() => address = scannedQR);
            controller.text = address;
        }
    }


    @override
    Widget build_with_state(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Bitcoin address", null, BackButton()),
            content: [
                AddressInput(controller),
                ButtonTips(),
            ],
            bumper: Bumper(context, content: [
                CustomButton(
                    txt: 'Continue',
                    onTap: onContinue, 
                    enabled: widget.addressValid
                ),
            ]),
        );
    }

//The following widgets can ONLY be used in this file

    Widget AddressInput(controller) {
        return CustomTextInput(
            controller: controller,
            error: widget.addressValid || controller.text.isEmpty ? "" : "Not a valid address",
            hint: 'Bitcoin address...',
        );
    }

    Widget BackButton() {
        return iconButton(() {
            navigateTo(context, BitcoinHome());
        }, 'left', 'lg');
    }

    Widget ButtonTips() {
        return Container(
            padding: const EdgeInsets.all(8),
            child: CustomColumn([
                CustomButton(
                    txt: 'Paste Clipboard', 
                    variant: 'secondary',
                    size: 'md',
                    expand: false,
                    icon: 'paste', 
                    onTap: onPaste,
                ),
                const CustomText(
                    variant: 'text',
                    font_size: 'sm',
                    text_color: 'text_secondary', 
                    txt: 'or'
                ),
                 CustomButton(
                    txt: 'Scan QR Code', 
                    variant: 'secondary',
                    size: 'md',
                    expand: false,
                    icon: 'qrcode', 
                    onTap: onScan,
                ),
            ], 8),
        );
    }
}
