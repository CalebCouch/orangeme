import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/scan_qr.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';

class Send extends StatefulWidget {
    Send({super.key});

    @override
    SendState createState() => SendState();
}

class SendState extends State<Send> {
    TextEditingController controller = TextEditingController();
    bool addressIsValid = true;
    String address = '';

    onContinue() {
        navigateTo(context, Amount(address));
    }

    @override
    void initState() {
        super.initState();
        controller.text = address;
        checkAddressValid(address);
    }

    onPaste() async {
        ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
        if (data != null) {
            checkAddressValid(data.text!);
            controller.text = data.text!;
            if (controller.text.startsWith("bitcoin:")) {
                controller.text = controller.text.replaceFirst("bitcoin:", "");
            }
        }
    }

    checkAddressValid(String address) {
        setState(() {
            addressIsValid = true;
            controller.text = address;
        });
    }

    Future<void> onScan() async {
        String scannedQR = await navigateToReturn(context, ScanQR());

        if (scannedQR != null) address = scannedQR;
        checkAddressValid(address);
    }


    @override
    Widget build(BuildContext context) {
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
                    enabled: addressIsValid
                ),
            ]),
        );
    }

//The following widgets can ONLY be used in this file

    Widget AddressInput(controller) {
        return CustomTextInput(
            controller: controller,
            onSubmitted: (String address) => {checkAddressValid(address)},
            error: addressIsValid || controller.text.isEmpty ? "" : "Not a valid address",
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
