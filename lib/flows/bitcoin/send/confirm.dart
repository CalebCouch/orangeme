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

class ConfirmSend extends StatefulWidget {
  final GlobalState globalState;
  final Transaction tx;
  const ConfirmSend(this.globalState, this.tx, {super.key});

  @override
  ConfirmState createState() => ConfirmState();
}

class ConfirmState extends State<ConfirmSend> {
  bool isLoading = false;
  final TextEditingController recipientAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  Future<void> onContinue() async {
    setState(() {
      isLoading = true;
    });
    await widget.globalState.invoke("broadcast_transaction", widget.tx.txid);
    navigateTo(context, Confirmation(widget.globalState, widget.tx.usd));
  }

  Widget buildScreen(BuildContext context, DartState state) {
    return Stack_Default(
      isLoading ? Container() : Header_Stack(context, "Confirm send"),
      [
        isLoading ? loadingCircle() : Container(),
        isLoading ? Container() : ConfirmAddress(context, widget.globalState, widget.tx),
        isLoading ? Container() : ConfirmAmount(context, widget.globalState, widget.tx),
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

ConfirmAddress(BuildContext context, GlobalState globalState, tx) {
  changeAddress() {
    Send(
      globalState,
      address: tx.sentAddress!,
    );
  }

  return DataItem(
    title: "Confirm Address",
    number: 1,
    subtitle: tx.sentAddress,
    helperText: "Bitcoin sent to the wrong address can never be recovered.",
    buttons: [
      CustomButton('Address', 'secondary md enabled hug edit', changeAddress),
    ],
  );
}

ConfirmAmount(BuildContext context, GlobalState globalState, tx) {
  changeAmount() {
    resetNavTo(
      context,
      SendAmount(globalState, tx.sentAddress!),
    );
  }

  changeSpeed() {
    resetNavTo(
      context,
      TransactionSpeed(
        globalState,
        tx.sentAddress!,
        tx.btc.abs(),
      ),
    );
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
