import 'package:flutter/material.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';
//import 'package:orange/global.dart' as global;

class ViewTransaction extends GenericWidget {
  String txid;
  ViewTransaction({super.key, required this.txid});

  @override
  ViewTransactionState createState() => ViewTransactionState();
}

class ViewTransactionState extends GenericState<ViewTransaction> {
  @override
  String stateName() {
    return "ViewTransaction";
  }

  @override
  int refreshInterval() {
    return 1;
  }

  @override
  String options() {
    return widget.txid;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {});
  }

  onDone() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    String direction = widget.tx.is_withdraw ? "Send" : "Received";
    return Stack_Default(
      Header_Stack(context, "$direction bitcoin"),
      [
        AmountDisplay(widget.tx.usd),
        transactionTabular(context, widget.tx),
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
        CustomText('heading ${dynamic_size(widget.tx.usd.length)}', '${widget.tx.usdUnformatted} USD'),
        CustomText('text lg text_secondary', '${widget.btc} BTC')
      ], AppPadding.valueDisplaySep),
    );
  }
}
