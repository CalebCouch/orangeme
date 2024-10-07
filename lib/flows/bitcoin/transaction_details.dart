import 'package:flutter/material.dart';

import 'package:orange/components/tabular.dart';

import 'package:orange/classes.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/util.dart';
import 'package:orangeme_material/orangeme_material.dart';

class ViewTransactionDetails extends StatefulWidget {
  final GlobalState globalState;
  final Transaction transaction;
  const ViewTransactionDetails(this.globalState, this.transaction, {super.key});

  @override
  ViewTransactionDetailsState createState() => ViewTransactionDetailsState();
}

class ViewTransactionDetailsState extends State<ViewTransactionDetails> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  onDone() {
    Navigator.pop(context);
  }

  Widget buildScreen(BuildContext context, DartState state) {
    String direction = widget.transaction.isReceive ? "Received" : "Sent";
    return Stack_Default(
      Header_Stack(context, "Confirm $direction"),
      [
        AmountDisplay(widget.transaction),
        transactionTabular(context, widget.transaction),
      ],
      Bumper(context, [CustomButton('Done', 'secondary lg enabled expand none', () => onDone())]),
    );
  }

  //The following widgets can ONLY be used in this file

  Widget AmountDisplay(tx) {
    dynamic_size(x) {
      if (x <= 4) return 'title';
      if (x <= 7) return 'h1';
      return 'h2';
    }

    double usd = (tx.usd.abs() - tx.fee.abs());
    double btc = (tx.btc).abs();

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: AppPadding.valueDisplay),
      child: CustomColumn([
        CustomText('heading ${dynamic_size(formatValue(usd).length)}', '$usd USD'),
        CustomText('text lg text_secondary', '${formatBTC(btc, 8)} BTC')
      ], AppPadding.valueDisplaySep),
    );
  }
}
