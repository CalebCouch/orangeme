import 'package:flutter/material.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/bitcoin/send/success.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/global.dart' as global;

class Confirm extends GenericWidget {
  final ExtTransaction tx;
  Confirm({super.key, required this.tx});
  @override
  ConfirmState createState() => ConfirmState();
}

class ConfirmState extends GenericState<Confirm> {
  @override
  String stateName() {
    return "Confirm";
  }

  @override
  int refreshInterval() {
    return 0;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {});
  }

  bool isLoading = false;
  final TextEditingController recipientAddressController = TextEditingController();

  Future<void> onContinue() async {
    setState(() {
      isLoading = true;
    });
    await global.invoke("broadcast_transaction", widget.tx.txid);
    navigateTo(context, Success(tx: widget.tx));
  }

  toBTC(double usd) {
    return usd; //to btc
  }

  @override
  Widget build(BuildContext context) {
    return Stack_Default(
      isLoading ? Container() : Header_Stack(context, "Confirm send"),
      [
        isLoading ? loadingCircle() : Container(),
        isLoading ? Container() : ConfirmAddress(context, widget.tx.tx.address),
        isLoading ? Container() : ConfirmAmount(context, widget.tx.tx.address, widget.tx.fee, widget.tx.tx.tx.usd, widget.tx.tx.tx.btc),
      ],
      isLoading ? Container() : Bumper(context, [CustomButton('Confirm & Send', 'primary lg enabled expand none', () => onContinue())]),
      isLoading ? Alignment.center : Alignment.topCenter,
      !isLoading,
    );
  }
}

//The following widgets can ONLY be used in this file

Widget loadingCircle() {
  return const Center(
    child: CircularProgressIndicator(
      strokeCap: StrokeCap.round,
      backgroundColor: ThemeColor.bgSecondary,
    ),
  );
}

ConfirmAddress(BuildContext context, String address) {
  changeAddress() {
    resetNavTo(context, Send());
  }

  return DataItem(
    title: "Confirm Address",
    number: 1,
    subtitle: address,
    helperText: "Bitcoin sent to the wrong address can never be recovered.",
    buttons: [
      CustomButton('Address', 'secondary md enabled hug edit', changeAddress),
    ],
  );
}

ConfirmAmount(BuildContext context, String address, String fee, String usd, String btc) {
  changeAmount() {
    resetNavTo(context, Amount(address: address));
  }

  changeSpeed() {
    resetNavTo(
      context,
      Speed(address: address, btc: double.parse(btc.split(' ')[0])),
    );
  }

  return DataItem(
    title: "Confirm Amount",
    number: 2,
    content: confirmationTabular(context, address, fee, usd, btc),
    buttons: [
      CustomButton('Amount', 'secondary md enabled hug edit', changeAmount),
      CustomButton('Speed', 'secondary md enabled hug edit', changeSpeed),
    ],
  );
}
