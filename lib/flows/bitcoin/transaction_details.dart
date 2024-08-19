import 'package:flutter/material.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/amount_display.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class TransactionDetailsWidget extends StatefulWidget {
  final GlobalState globalState;
  final Transaction transaction;
  const TransactionDetailsWidget(this.globalState, this.transaction,
      {super.key});

  @override
  TransactionDetailsWidgetState createState() =>
      TransactionDetailsWidgetState();
}

class TransactionDetailsWidgetState extends State<TransactionDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  Widget buildScreen(BuildContext context, DartState state) {
    String direction = widget.transaction.isReceive ? "Received" : "Sent";

    return Interface(
      widget.globalState,
      header: stackHeader(context, "$direction bitcoin"),
      content: Content(
        content: Column(
          children: [
            AmountDisplay(
              (widget.transaction.usd.abs() - widget.transaction.fee.abs()),
              (widget.transaction.btc).abs(),
            ),
            const Spacing(height: AppPadding.content),
            transactionTabular(context, widget.transaction),
          ],
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Done",
        () {
          Navigator.pop(context);
        },
        true,
        ButtonVariant.secondary,
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
