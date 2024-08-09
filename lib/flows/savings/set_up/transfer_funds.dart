import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/placeholder.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/flows/savings/set_up/completed_mobile.dart';

import 'package:orange/util.dart';

class TransferFunds extends StatefulWidget {
  final GlobalState globalState;
  const TransferFunds(this.globalState, {super.key});

  @override
  State<TransferFunds> createState() => TransferFundsState();
}

class TransferFundsState extends State<TransferFunds> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  Widget build_screen(BuildContext context, DartState state) {
    return DefaultInterface(
      resizeToAvoidBottomInset: false,
      header: stackHeader(
        context,
        "Transfer funds",
      ),
      content: Content(
        content: Column(children: [
          placeholder(
            context,
            "The last step is to move your funds to your upgraded and more secure wallet.\n\norange.me does not charge for this, but there is a fee for all bitcoin transactions paid to to the bitcoin network",
          ),
          feeItem(context, 4.75)
        ]),
      ),
      bumper: singleButtonBumper(
        context,
        "Confirm",
        () {
          navigateTo(context, CompletedMobile(widget.globalState));
        },
      ),
    );
  }
}

Widget feeItem(BuildContext context, double fee) {
  return DataItem(
    title: 'Confirm Fee',
    content: Container(
        padding: const EdgeInsets.only(top: AppPadding.dataItem),
        child: SingleTab(title: 'Fee', subtitle: '\$$fee USD')),
  );
}
