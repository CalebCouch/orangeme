import 'package:flutter/material.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/bitcoin/send/success.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';

class Confirm extends StatefulWidget {
    final ExtTransaction tx;
    const Confirm({super.key, required this.tx});

    @override
    ConfirmState createState() => ConfirmState();
}

class ConfirmState extends State<Confirm> {
    bool isLoading = false;

    Future<void> onContinue() async {
        setState(() {
            isLoading = true;
        });
        //broadcastTx(path: global.dataDir!);
        setState(() {
            isLoading = false;
        });
        navigateTo(context, Success());
    }

    @override
    Widget build(BuildContext context) {
        BasicTransaction basicTx = widget.tx.tx;
        ShorthandTransaction shTx = basicTx.tx;
        return Stack_Default(
            header: Header_Stack(context, "Confirm send"),
            content: [
                ConfirmAddress(context, basicTx.address),
                ConfirmAmount(context, widget.tx, basicTx, shTx),
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

//The following widgets can ONLY be used in this file

ConfirmAddress(BuildContext context, String address) {
    changeAddress() {
        resetNavTo(context, Send());
    }
    return DataItem(
        title: "Confirm Address",
        number: 1,
        subtitle: address,
        helperText: "Bitcoin sent to the wrong address can never be recovered.",
        buttons: [ editButton('Address', changeAddress)],
    );
}

ConfirmAmount(BuildContext context, ExtTransaction tx, BasicTransaction basicTx, ShorthandTransaction shTx) {
    changeAmount() {
        resetNavTo(context, Amount());
    }

    changeSpeed() {
        resetNavTo(context, Speed());
    }

    return DataItem(
        title: "Confirm Amount",
        number: 2,
        content: Column(
            children: [
                SingleTab(title: "Send to Address", subtitle: transactionCut(basicTx.address)),
                SingleTab(title: "Amount Sent", subtitle: "${shTx.btc} BTC"),
                SingleTab(title: "USD Value Sent", subtitle: shTx.usd),
                SingleTab(title: "Fee", subtitle: tx.fee),
            ],
        ),
        buttons: [
            editButton('Amount', changeAmount),
            editButton('Speed', changeSpeed),
        ], 
    );
}

Widget editButton(text, onTap){
    return CustomButton(
        txt: text, 
        variant: 'secondary',
        size: 'md',
        expand: false,
        icon: 'edit', 
        onTap: onTap,
    );
}
