import 'package:flutter/material.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/bitcoin/send/success.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/components/data_item.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';

class Confirm extends GenericWidget {
    Confirm({super.key});

    String address_cut = '';
    String address_whole = '';
    String amount_btc = '';
    String amount_usd = '';
    String fee = '';
    String total = '';

    @override
    ConfirmState createState() => ConfirmState();
}

class ConfirmState extends GenericState<Confirm> {
    bool isLoading = false;

    @override
    PageName getPageName() {
        return PageName.confirm();
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
            widget.fee = json["fee"] as String;
            widget.total = json["total"] as String;
        });
    }

    @override
    void initState() {
        setState(() {
            isLoading = false;
        });
        super.initState();
    }

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

    ConfirmAmount(BuildContext context, tx) {
        changeAmount() {resetNavTo(context, Amount());}
        changeSpeed() {resetNavTo(context, Speed());}

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
                SingleTab(title: "Fee", subtitle: widget.fee),
            ],
        );
    }
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
