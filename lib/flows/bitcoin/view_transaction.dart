import 'package:flutter/material.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orangeme_material/orangeme_material.dart';

import 'package:orange/global.dart' as global;

class ViewTransaction extends GenericWidget {
    String txid;
    ViewTransaction({super.key, required this.txid});

    bool is_withdraw = true;
    String time = "12:34 PM";
    String date = "12/8/24";
    String address = "123456789...123";
    String amount_btc = "0.00001234 BTC";
    String amount_usd = "\$12.00";
    String price = "\$73,802.34";
    String? fee = "\$0.12";
    String? total = "\$12.12";

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
            widget.is_withdraw = json["is_withdraw"] as bool;
            widget.time = json["time"] as String; //"12:34 PM"
            widget.date = json["date"] as String; //"12/8/24"
            widget.address = json["address"] as String; //"123456789...123"
            widget.amount_btc = json["amount_btc"] as String; //"0.00001234 BTC"
            widget.amount_usd = json["amount_usd"] as String; //"$12.00"
            widget.price = json["price"] as String; //"$73,802.34"
            widget.fee = json["fee"] as String?; //"$0.12"
            widget.total = json["total"] as String?; //"$12.12"
        });
    }

    onDone() {
        Navigator.pop(context);
    }

    Widget build_with_state(BuildContext context) {
        String header_text = widget.is_withdraw ? "Sent bitcoin" : "Received bitcoin";

        return Stack_Default(
            header: Header_Stack(context, header_text),
            content: [
                BalanceDisplay(),
                TransactionData(),
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

    Widget BalanceDisplay() {
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
                            txt: widget.amount_usd
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
                                text_color: 'text_secondary',
                                txt: widget.amount_btc
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }

    Widget TransactionData() {
        String direction = widget.is_withdraw ? "Sent" : "Received";
        String address_direction = widget.is_withdraw ? "$direction to Address" : "Received from Address";
        return Column(
            children: [
                SingleTab(title: "Date", subtitle: widget.date),
                SingleTab(title: "Time", subtitle: widget.time),
                SingleTab(title: address_direction, subtitle: widget.address),
                SingleTab(title: "Amount $direction", subtitle: widget.amount_btc),
                SingleTab(title: "Bitcoin Price", subtitle: widget.price),
                SingleTab(title: "USD Value $direction", subtitle: widget.amount_usd),
                
                widget.is_withdraw ? const Spacing(AppPadding.content) : Container(),
                widget.fee != null ? SingleTab(title: "Fee", subtitle: widget.fee!) : Container(),
                widget.total != null ? SingleTab(title: "Total Amount", subtitle: widget.total!) : Container(),
            ],
        );
    }
}