import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/scan_qr.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';

class Send extends StatefulWidget {
  double balance;
  double price;
  Send(this.balance, this.price, {super.key});

  @override
  SendState createState() => SendState();
}

class SendState extends State<Send> {
  bool addressIsValid = true;
  bool isLoading = false;
  String status = 'disabled';
  String address = '';

  onContinue() {
    if (addressIsValid) {
      navigateTo(context, Amount(widget.balance, widget.price, address));
    }
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
      status = addressIsValid ? 'enabled' : 'disabled';
    });
  }

  onScan() async {
    String? scannedCode = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const ScanQR(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
    setState(() {
      address = scannedCode ?? '';
    });
  }

  backButton() {
    return iconButton(() {
      navigateTo(context, BitcoinHome());
    }, 'left lg');
  }

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack_Default(
      Header_Stack(context, "Bitcoin address", null, backButton()),
      [
        AddressInput(controller),
        ButtonTips(),
      ],
      Bumper(context, [
        CustomButton('Continue', 'primary lg expand none', onContinue, status),
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

  Widget ButtonTips() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: CustomColumn([
        CustomButton('Paste Clipboard', 'secondary md hug paste', onPaste, 'enabled'),
        const CustomText('text sm text_secondary', 'or'),
        CustomButton('Scan QR Code', 'secondary md hug qrcode', onScan, 'enabled'),
      ], 8),
    );
  }
}
