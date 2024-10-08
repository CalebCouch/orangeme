import 'package:flutter/material.dart';
import 'package:orange/classes.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/scan_qr.dart';
import 'package:orange/util.dart';
import 'package:orangeme_material/orangeme_material.dart';

class Send extends StatefulWidget {
  final GlobalState globalState;
  final String? address;
  const Send(this.globalState, {super.key, this.address});

  @override
  SendState createState() => SendState();
}

class SendState extends State<Send> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  @override
  initState() {
    controller.text = addressStr;
    setAddress(widget.address ?? "");
    super.initState();
  }

  String addressStr = '';
  bool addressValid = false;

  Future<void> setAddress(String address) async {
    if (address.contains('bitcoin:')) address = address.substring(8);
    checkAddress(address);
    setState(() {
      addressStr = address;
      controller.text = addressStr;
    });
  }

  //This function only checks the address validity
  Future<void> checkAddress(String address) async {
    if (address.contains('bitcoin:')) address = address.substring(8);
    var valid = (await widget.globalState.invoke("check_address", address)).data == "true";
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

  onPaste() async {
    String data = (await getClipBoardData()).toString();
    if (data != "null") {
      setAddress(data);
    }
  }

  onScan() {
    switchPageTo(context, ScanQR(widget.globalState));
  }

  final TextEditingController controller = TextEditingController();

  Widget buildScreen(BuildContext context, DartState state) {
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
