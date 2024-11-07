import 'package:flutter/material.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/bitcoin/send/success.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/global.dart' as global;

class Confirm extends GenericWidget {
  Confirm({super.key});

  late ExtTransaction tx;

  ConfirmState createState() => ConfirmState();
}

class ConfirmState extends GenericState<Confirm> {
  @override
  String stateName() {
    return "ConfirmTransaction";
  }

  @override
  int refreshInterval() {
    return 0;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
      widget.tx = ExtTransaction.fromJson(json['transaction']);
    });
  }

  bool isLoading = false;

  Future<void> onContinue() async {
    setState(() {
      isLoading = true;
    });
    broadcastTx(path: global.dataDir!);
    setState(() {
      isLoading = false;
    });
    navigateTo(context, Success());
  }

  @override
  Widget build(BuildContext context) {
    BasicTransaction basicTx = widget.tx.tx;
    ShorthandTransaction shTx = basicTx.tx;

    return Stack_Default(
      isLoading ? Container() : Header_Stack(context, "Confirm send"),
      [
        isLoading ? loadingCircle() : Container(),
        isLoading ? Container() : ConfirmAddress(context, basicTx.address),
        isLoading ? Container() : ConfirmAmount(context, widget.tx, basicTx, shTx),
      ],
      isLoading ? Container() : Bumper(context, [CustomButton('Confirm & Send', 'primary lg expand none', () => onContinue(), 'enabled')]),
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
      CustomButton('Address', 'secondary md hug edit', changeAddress, 'enabled'),
    ],
  );
}

ConfirmAmount(BuildContext context, ExtTransaction tx, BasicTransaction basicTx, ShorthandTransaction shTx) {
  changeAmount() {
    resetNavTo(context, Amount());
  }

  changeSpeed() {
    resetNavTo(context, Speed());
  }

  return DataItem(
    title: "Confirm Amount",
    number: 2,
    content: Column(
      children: [
        SingleTab(title: "Send to Address", subtitle: transactionCut(basicTx.address)),
        SingleTab(title: "Amount Sent", subtitle: "${shTx.btc} BTC"),
        SingleTab(title: "USD Value Sent", subtitle: shTx.usd),
        SingleTab(title: "Fee", subtitle: tx.fee),
      ],
    ),
    buttons: [
      CustomButton('Amount', 'secondary md hug edit', changeAmount, 'enabled'),
      CustomButton('Speed', 'secondary md hug edit', changeSpeed, 'enabled'),
    ],
  );
}
