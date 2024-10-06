import 'package:flutter/material.dart';
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
    await widget.globalState.invoke("broadcast_transaction", widget.tx.txid);
    navigateTo(context, Confirmation(widget.globalState, widget.tx.usd));
  }

  Widget buildScreen(BuildContext context, DartState state) {
    return Stack_Default(
      Header_Stack(context, "Confirm send"),
      [
        ConfirmAddress(context, widget.globalState, widget.tx),
        ConfirmAmount(context, widget.globalState, widget.tx),
      ],
      Bumper([CustomButton('Confirm & Send', 'primary lg enabled expand none', () => onContinue())]),
    );
  }
}

//The following widgets can ONLY be used in this file

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
    content: CustomColumn([
      CustomText('text md', tx.sentAddress!),
      const CustomText('text sm text_secondary', "Bitcoin sent to the wrong address can never be recovered."),
    ], 16),
    buttons: [
      CustomButton('Address', 'secondary md enabled hug edit', changeAddress()),
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
    title: "Confirm Address",
    number: 1,
    content: CustomColumn([
      CustomText('text md', tx.sentAddress!),
      const CustomText('text sm text_secondary', "Bitcoin sent to the wrong address can never be recovered."),
    ], 16),
    buttons: [
      CustomButton('Amount', 'secondary md enabled hug edit', changeAmount()),
      CustomButton('Speed', 'secondary md enabled hug edit', changeSpeed()),
    ],
  );
}
