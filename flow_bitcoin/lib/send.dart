import 'package:flow_bitcoin/flow_bitcoin.dart';

import 'package:material/navigation.dart';
import 'package:material/material.dart';


class Send extends GenericWidget {
    String address;
    String amount;

    Send({super.key, this.address = '', this.amount = ''});

    bool addressValid = true;

    @override
    SendState createState() => SendState();
}

class SendState extends GenericState<Send> {
    TextEditingController controller = TextEditingController();

    @override
    PageName getPageName() {
        return PageName.send(widget.address);
    }

    @override
    void unpack_state(Map<String, dynamic> json) {
        widget.addressValid = json["valid_address"] as bool;
    }
    
    void initState() {
        super.initState();
        controller.text = widget.address;
    }

    onContinue() {
        navigateTo(context, Amount(widget.address, amount: widget.amount));
    }

    onPaste() async {
        ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
        if (data != null) {setState(() => controller.text = widget.address = data.text!);}
    }

    Future<void> onScan() async {
        String? scannedQR = await navigateToReturn(context, ScanQR());
        if (scannedQR != null) {setState(() => controller.text = widget.address = scannedQR ?? widget.address);}
    }


    @override
    Widget build_with_state(BuildContext context) {
        //print(widget.addressValid);
        return Stack_Default(
            header: Header_Stack(context, "Bitcoin address", null, UniBackButton(context, BitcoinHome())),
            content: [
                AddressInput(),
                ButtonTips(),
            ],
            bumper: Bumper(context, content: [
                CustomButton(
                    txt: 'Continue',
                    onTap: onContinue,
                    enabled: widget.addressValid && controller.text.isNotEmpty,
                ),
            ]),
        );
    }


    Widget AddressInput() {
        return CustomTextInput(
            controller: controller,
            error: widget.addressValid || controller.text.isEmpty ? "" : "Not a valid address",
            hint: 'Bitcoin address...',
            onSubmitted: (String _str) => widget.address = _str,
            onChanged: (String _str) => widget.address = _str,
        );
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
