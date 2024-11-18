import 'package:flutter/material.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/bitcoin/send/success.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/components/data_item.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orangeme_material/orangeme_material.dart';

class Confirm extends GenericWidget {
    String address;
    BigInt amount;
    BigInt fee;

    Confirm(this.address, this.amount, this.fee, {super.key});

    String raw_tx = "";

    String address_cut = '';
    String address_whole = '';
    String amount_btc = '';
    String amount_usd = '';
    String fee_usd = '';
    String total = '';

    @override
    ConfirmState createState() => ConfirmState();
}

class ConfirmState extends GenericState<Confirm> {
    bool isLoading = false;

    @override
    PageName getPageName() {
        print("widget.fee == ${widget.fee}");
        return PageName.confirm(widget.address, widget.amount, widget.fee);
    }

    @override
    int refreshInterval() {
        return 0;
    }

    @override
    void unpack_state(Map<String, dynamic> json) {
        setState(() {
            widget.address_cut = json["address_cut"] as String;
            widget.address_whole = json["address_whole"] as String;
            widget.amount_btc = json["amount_btc"] as String;
            widget.amount_usd = json["amount_usd"] as String;
            widget.fee_usd = json["fee_usd"] as String;
            widget.total = json["total"] as String;
            widget.raw_tx = json["raw_tx"] as String;
        });
    }

    onContinue() {
        navigateTo(context, Success(widget.raw_tx, widget.amount_usd));
    }


    @override
    Widget build_with_state(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Confirm send"),
            content: [
                ConfirmAddress(),
                ConfirmAmount(),
            ],
            bumper: Bumper(context, content: [ 
                CustomButton(
                    txt: 'Confirm & Send',
                    onTap: () => onContinue()
                )
            ]),
            isLoading: isLoading,
        );
    }



    ConfirmAddress() {
        changeAddress() {resetNavTo(context, Send());}

        return DataItem(
            title: "Confirm Address",
            number: 1,
            subtitle: widget.address_whole,
            helperText: "Bitcoin sent to the wrong address can never be recovered.",
            buttons: [EditButton('Address', changeAddress)],
        );
    }

    ConfirmAmount() {
        changeAmount() {resetNavTo(context, Amount(widget.address));}
        changeSpeed() {resetNavTo(context, Speed(widget.address, widget.amount));}

        return DataItem(
            title: "Confirm Amount",
            number: 2,
            content: Details(),
            buttons: [
                EditButton('Amount', changeAmount),
                EditButton('Speed', changeSpeed),
            ], 
        );
    }

    Widget Details(){
        return Column(
            children: [
                SingleTab(title: "Send to Address", subtitle: widget.address_cut),
                SingleTab(title: "Amount Sent", subtitle: widget.amount_btc),
                SingleTab(title: "USD Value Sent", subtitle: widget.amount_usd),
                SingleTab(title: "Fee", subtitle: widget.fee_usd),
            ],
        );
    }
}

CustomButton EditButton(text, onTap){
    return CustomButton(
        txt: text, 
        variant: 'secondary',
        size: 'md',
        expand: false,
        icon: 'edit', 
        onTap: onTap,
    );
}
