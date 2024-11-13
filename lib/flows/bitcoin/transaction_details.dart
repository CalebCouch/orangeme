import 'package:flutter/material.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';
//import 'package:orange/global.dart' as global;

class ViewTransaction extends GenericWidget {
  String txid;
  ViewTransaction({super.key, required this.txid});

  late BasicTransaction? basic_transaction;
  late ExtTransaction? ext_transaction;

  @override
  ViewTransactionState createState() => ViewTransactionState();
}

class ViewTransactionState extends GenericState<ViewTransaction> {
  @override
  PageName getPageName() {
    return PageName.viewTransaction(widget.txid);
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
    setState(() {
      widget.basic_transaction = json['basic_transaction'] != null ? BasicTransaction.fromJson(json['basic_transaction']) : null;
      widget.ext_transaction = json['ext_transaction'] != null ? ExtTransaction.fromJson(json['ext_transaction']) : null;
    });
  }

  onDone() {
    Navigator.pop(context);
  }

  Widget build_with_state(BuildContext context) {
    BasicTransaction tx;
    if (widget.basic_transaction != null) {
      tx = widget.basic_transaction!;
    } else if (widget.ext_transaction != null) {
      tx = widget.ext_transaction!.tx;
    } else {
      return Center(child: Text('Transaction data not available'));
    }

    String direction = tx.tx.is_withdraw ? "Sent" : "Received";

    return Stack_Default(
      Header_Stack(context, "$direction bitcoin"),
      [
        BalanceDisplay(tx),
        if (direction == 'Received') transactionTabular(context, tx),
        if (direction == 'Sent') sendTransactionTabular(context, widget.ext_transaction!),
      ],
      Bumper(context, [CustomButton('Done', 'secondary lg expand none', () => onDone(), 'enabled')]),
    );
  }
  //The following widgets can ONLY be used in this file

  Widget BalanceDisplay(BasicTransaction tx) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: CustomText('heading title', tx.tx.usd),
          ),
          const Spacing(8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [CustomText('text lg text_secondary', '${tx.tx.btc} BTC')],
            ),
          ),
        ],
      ),
    );
  }
}
