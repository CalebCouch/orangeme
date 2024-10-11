import 'package:flutter/material.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';
//import 'package:orange/global.dart' as global;

class TransactionDetails extends GenericWidget {
  final Transaction transaction;
  TransactionDetails(this.transaction, {super.key});

  double usdUnformatted = 0; // (tx.usd.abs() - tx.fee.abs());

  String usd = ""; //formatValue(usd);
  String btc = ""; //formatBTC((tx.btc).abs(), 8)
  bool isReceive = true;

  @override
  TransactionDetailsState createState() => TransactionDetailsState();
}

class TransactionDetailsState extends GenericState<TransactionDetails> {
  @override
  String stateName() {
    return "TransactionDetails";
  }

  @override
  int refreshInterval() {
    return 1;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
      widget.usd;
      widget.btc;
      widget.transaction; //Need to know if transaction was sent or received
      widget.isReceive;
    });
  }

  onDone() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    String direction = widget.isReceive ? "Received" : "Sent";
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

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: AppPadding.valueDisplay),
      child: CustomColumn([
        CustomText('heading ${dynamic_size(widget.usd.length)}', '${widget.usdUnformatted} USD'),
        CustomText('text lg text_secondary', '${widget.btc} BTC')
      ], AppPadding.valueDisplaySep),
    );
  }
}
