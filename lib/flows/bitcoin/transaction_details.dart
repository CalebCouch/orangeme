import 'package:flutter/material.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';


///////////////////////////////////////////////////

// FIX THIS AFTER TRANSACTION TYPES ARE DEFINED //

///////////////////////////////////////////////////

import 'package:orange/global.dart' as global;

class ViewTransaction extends GenericWidget {
    String txid;
    ViewTransaction({super.key, required this.txid});

    late bool is_withdraw;
    late ReceivedTransaction? received_tx;
    late SentTransaction? sent_tx;

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
    void unpack_state(Map<String, dynamic> json) {
        setState(() {
            // is it possible to only give this page one transaction, if so, i won't need the boolean
            widget.is_withdraw = json["is_withdraw"] as bool;
            widget.received_tx = ReceivedTransaction?.fromJson(json['received_tx']);
            widget.sent_tx = SentTransaction?.fromJson(json['sent_tx']);
        });
    }

    onDone() {
        Navigator.pop(context);
    }

    Widget build_with_state(BuildContext context) {
        dynamic tx = is_withdraw ? widget.sent_tx : widget.received_tx;
        String header_text = is_withdraw ? "Sent bitcoin" : "Received bitcoin";

        return Stack_Default(
            header: Header_Stack(context, header_text),
            content: [
                BalanceDisplay(tx),
                if (!is_withdraw) ReceivedTabular(context, tx),
                if (is_withdraw) SentTabular(context, tx),
            ],
            bumper: Bumper(context, content: [
                CustomButton(
                    txt:'Done', 
                    variant: 'secondary',
                    onTap: () => onDone()
                ),
            ]),
        );
    }


    
  //The following widgets can ONLY be used in this file

    Widget BalanceDisplay(dynamic tx) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CustomText(
                            variant:'heading', 
                            font_size: 'title', 
                            txt: tx.amount_usd
                        ),
                    ),
                    const Spacing(8),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [CustomText(
                                variant: 'text',
                                font_size: 'lg',
                                text_color 'text_secondary', 
                                txt: tx.amount_btc
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}

Widget SentTabular(BuildContext context, SentTransaction tx) {
    return Column(
        children: [
            SingleTab(title: "Date", subtitle: tx.date),
            SingleTab(title: "Time", subtitle: tx.time),
            SingleTab(title: "Sent to Address", subtitle: tx.address),
            SingleTab(title: "Amount Sent", subtitle: tx.amount_btc),
            SingleTab(title: "Bitcoin Price", subtitle: tx.price),
            SingleTab(title: "USD Value Sent", subtitle: tx.amount_usd),
            const Spacing(AppPadding.content),
            SingleTab(title: "Fee", subtitle: tx.fee),
            SingleTab(title: "Total Amount", subtitle: tx.total),
        ],
    );
}

Widget ReceivedTabular(BuildContext context, ReceivedTransaction tx) {
    return Column(
        children: [
            SingleTab(title: "Date", subtitle: tx.date),
            SingleTab(title: "Time", subtitle: tx.time),
            SingleTab(title: "Received from Address", subtitle: tx.address),
            SingleTab(title: "Amount Sent", subtitle: tx.amount_btc),
            SingleTab(title: "Bitcoin Price", subtitle: tx.price),
            SingleTab(title: "USD Value Received", subtitle: tx.amount_usd),
        ],
    );
}
