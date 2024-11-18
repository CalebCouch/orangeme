import 'package:flutter/material.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/bitcoin/send/success.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/components/data_item.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';

class Confirm extends StatefulWidget {
    final BuildingTransaction tx;
    const Confirm({super.key, required this.tx});

    @override
    ConfirmState createState() => ConfirmState();
}

/*
pub struct BuildingTransaction {
    pub date: String, // "10:45 PM"g
    pub time: String, // "11/12/24"
    pub amount_usd: String, // "$10.00"
    pub amount_btc: String, // "0.00001234 BTC"
    pub address_whole: String, // "ack9723dxsahkdob239u1dumoiuhare482u"
    pub address_cut: String, // "123456789...123"
    pub fee: String, // "$0.14"
}
*/

class ConfirmState extends State<Confirm> {
    bool isLoading = false;

    Future<void> onContinue() async {
        setState(() => isLoading = true);

        // Broadcast the transaction here //

        setState(() => isLoading = false);

        navigateTo(context, Success());
    }


    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Confirm send"),
            content: [
                ConfirmAddress(context, tx.address_whole),
                ConfirmAmount(context, widget.tx),
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
}


ConfirmAddress(BuildContext context, String address) {
    changeAddress() {resetNavTo(context, Send());}

    return DataItem(
        title: "Confirm Address",
        number: 1,
        subtitle: address,
        helperText: "Bitcoin sent to the wrong address can never be recovered.",
        buttons: [EditButton('Address', changeAddress)],
    );
}

ConfirmAmount(BuildContext context, tx) {
    changeAmount() {resetNavTo(context, Amount());}
    changeSpeed() {resetNavTo(context, Speed());}

    return DataItem(
        title: "Confirm Amount",
        number: 2,
        content: Details(tx),
        buttons: [
            EditButton('Amount', changeAmount),
            EditButton('Speed', changeSpeed),
        ], 
    );
}

Widget EditButton(text, onTap){
    return CustomButton(
        txt: text, 
        variant: 'secondary',
        size: 'md',
        expand: false,
        icon: 'edit', 
        onTap: onTap,
    );
}

Widget Details(tx){
    return Column(
        children: [
            SingleTab(title: "Send to Address", subtitle: tx.address_cut),
            SingleTab(title: "Amount Sent", subtitle: tx.amount_btc),
            SingleTab(title: "USD Value Sent", subtitle: tx.amount_usd),
            SingleTab(title: "Fee", subtitle: tx.fee),
        ],
    );
}
