import 'package:flutter/material.dart';
import 'package:orange/flows/bitcoin/send/confirm.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'dart:convert';

import 'package:orangeme_material/orangeme_material.dart';

class TransactionSpeed extends StatefulWidget {
  final GlobalState globalState;
  final String address;
  final double btc;

  const TransactionSpeed(this.globalState, this.address, this.btc, {super.key});

  @override
  TransactionSpeedState createState() => TransactionSpeedState();
}

class TransactionSpeedState extends State<TransactionSpeed> {
  int index = 0;
  bool isLoading = false;

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
  void initState() {
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  Future<void> onContinue() async {
    setState(() {
      isLoading = true;
    });
    Transaction tx = Transaction.fromJson(
        jsonDecode((await widget.globalState.invoke("create_legacy_transaction", "${widget.address}|${widget.btc}|$index")).data));
    navigateTo(context, ConfirmSend(widget.globalState, tx));
    setState(() {
      isLoading = false;
    });
  }

  Widget buildScreen(BuildContext context, DartState state) {
    var fees = widget.globalState.state.value.fees;

    return Stack_Default(
      isLoading ? Container() : Header_Stack(context, "Transaction speed"),
      [isLoading ? loadingCircle() : SpeedSelector(fees)],
      isLoading ? Container() : Bumper(context, [CustomButton('Continue', 'primary lg enabled expand none', () => onContinue())]),
    );
  }

  //The following widgets can ONLY be used in this file

  Widget SpeedSelector(fees) {
    return CustomColumn([
      radioButton(
        "Standard",
        "Arrives in ~2 hours\n\$${formatValue(fees[0])} bitcoin network fee",
        index == 0,
        () {
          setState(() {
            index = 0;
          });
        },
      ),
      radioButton(
        "Priority",
        "Arrives in ~30 minutes\n\$${formatValue(fees[1])} bitcoin network fee",
        index == 1,
        () {
          setState(() {
            index = 1;
          });
        },
      )
    ]);
  }

  Widget loadingCircle() {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(
          strokeCap: StrokeCap.round,
          backgroundColor: ThemeColor.bgSecondary,
        ),
      ),
    );
  }
}

Widget radioButton(String title, String subtitle, bool isEnabled, onTap) {
  String icon = isEnabled ? 'radioFilled' : 'radio';
  return InkWell(
    onTap: onTap,
    child: Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomIcon('$icon lg', key: UniqueKey()),
          const Spacing(16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: CustomColumn([
              CustomText('heading h5', title, alignment: TextAlign.left),
              CustomText('text sm text_secondary', subtitle, alignment: TextAlign.left),
            ], 8, true, false),
          ),
        ],
      ),
    ),
  );
}
