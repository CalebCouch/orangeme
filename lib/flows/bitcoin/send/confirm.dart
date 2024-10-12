import 'package:flutter/material.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/bitcoin/send/success.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/components/data_item.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';
//import 'package:orange/global.dart' as global;

class Confirm extends GenericWidget {
  Confirm({super.key});

  Transaction tx = [] as Transaction; // the transaction being built

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
    setState(() {
      widget.tx;
    });
  }

  bool isLoading = false;
  final TextEditingController recipientAddressController = TextEditingController();

  Future<void> onContinue() async {
    setState(() {
      isLoading = true;
    });
    //await widget.globalState.invoke("broadcast_transaction", widget.tx.txid);
    navigateTo(context, Success());
  }

  @override
  Widget build(BuildContext context) {
    return Stack_Default(
      isLoading ? Container() : Header_Stack(context, "Confirm send"),
      [
        isLoading ? loadingCircle() : Container(),
        isLoading ? Container() : ConfirmAddress(context, widget.tx),
        isLoading ? Container() : ConfirmAmount(context, widget.tx),
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

ConfirmAddress(BuildContext context, tx) {
  changeAddress() {
    Send();
  }

  return DataItem(
    title: "Confirm Address",
    number: 1,
    subtitle: tx.address,
    helperText: "Bitcoin sent to the wrong address can never be recovered.",
    buttons: [
      CustomButton('Address', 'secondary md enabled hug edit', changeAddress),
    ],
  );
}

ConfirmAmount(BuildContext context, tx) {
  changeAmount() {
    resetNavTo(context, Amount());
  }

  changeSpeed() {
    resetNavTo(context, Speed());
  }

  return DataItem(
    title: "Confirm Amount",
    number: 2,
    content: confirmationTabular(context, tx),
    buttons: [
      CustomButton('Amount', 'secondary md enabled hug edit', changeAmount),
      CustomButton('Speed', 'secondary md enabled hug edit', changeSpeed),
    ],
  );
}
