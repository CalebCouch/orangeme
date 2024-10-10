import 'package:flutter/material.dart';
import 'package:orange/classes.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/scan_qr.dart';
import 'package:orange/util.dart';
import 'package:orangeme_material/orangeme_material.dart';
//import 'package:orange/global.dart' as global;

class Send extends GenericWidget {
  final String? address;
  Send({super.key, this.address});

  @override
  SendState createState() => SendState();
}

class SendState extends GenericState<Send> {
  @override
  String stateName() {
    return "Send";
  }

  @override
  int refreshInterval() {
    return 0;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {});
  }

  String addressStr = '';
  bool addressValid = false;

  Future<void> setAddress(String address) async {
    checkAddress(address);
    setState(() {
      addressStr = address;
      controller.text = addressStr;
    });
  }

  //This function only checks the address validity
  Future<void> checkAddress(String address) async {
    var valid = true; // (await widget.globalState.invoke("check_address", address)).data == "true";
    setState(() {
      addressValid = valid;
    });
  }

  onContinue() {
    checkAddress(controller.text);
    if (addressValid) {
      navigateTo(context, Amount());
    }
  }

  onPaste() {
    String data = ''; // Need to get clipboard data
    if (data != "null") {
      setAddress(data);
    }
  }

  onScan() {
    switchPageTo(context, ScanQR());
  }

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack_Default(
      Header_Stack(context, "Bitcoin address"),
      [
        AddressInput(controller),
        ButtonTips(),
      ],
      Bumper(context, [
        CustomButton('Continue', 'primary lg enabled expand none', onContinue),
      ]),
    );
  }

//The following widgets can ONLY be used in this file

  Widget AddressInput(controller) {
    return CustomTextInput(
      controller: controller,
      onSubmitted: (String address) => {setAddress(address)},
      onChanged: (String address) => {checkAddress(address)},
      error: addressValid || addressStr.isEmpty ? "" : "Not a valid address",
      hint: 'Bitcoin address...',
    );
  }

  Widget ButtonTips() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: CustomColumn([
        CustomButton('Paste Clipboard', 'secondary md enabled hug paste', onPaste),
        const CustomText('text sm text_secondary', 'or'),
        CustomButton('Scan QR Code', 'secondary md enabled hug qrcode', onScan),
      ], 8),
    );
  }
}
