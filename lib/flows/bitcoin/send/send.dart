import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/classes.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/scan_qr.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/global.dart' as global;

class Send extends GenericWidget {
  Send({super.key});
  bool valid = true;
  String address = '';

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
    return 100;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
      widget.valid = json["valid"];
      widget.address = json["address"];
    });
  }

  bool isLoading = false;
  String status = 'disabled';

  onContinue() {
    print('continuing');
    if (widget.valid) {
      setAddress(controller.text);
      navigateTo(context, Amount());
    }
  }

  onPaste() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      setAddress(data.text!);
      controller.text = data.text!;
    }
  }

  setAddress(String a) {
    setStateAddress(path: global.dataDir!, address: a);
    setState(() {
      status = widget.valid ? 'enabled' : 'disabled';
    });
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
        CustomButton('Continue', 'primary lg expand none', onContinue, status),
      ]),
    );
  }

//The following widgets can ONLY be used in this file

  Widget AddressInput(controller) {
    return CustomTextInput(
      controller: controller,
      onSubmitted: (String address) => {setAddress(address)},
      error: widget.valid || controller.text.isEmpty ? "" : "Not a valid address",
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
