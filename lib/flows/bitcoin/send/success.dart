import 'package:flutter/material.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/components/result.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/generic.dart';

class Success extends GenericWidget {
    String rawTx;
    String amount_usd;

    Success(this.rawTx, this.amount_usd, {super.key});

    @override
    SuccessState createState() => SuccessState();
}

class SuccessState extends GenericState<Success> {

    @override
    PageName getPageName() {
        return PageName.success(widget.rawTx);
    }

    @override
    int refreshInterval() {
        return 0;
    }

    @override
    void unpack_state(Map<String, dynamic> json) {}

    Widget build_with_state(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Send confirmed", Container(), ExitButton(context, BitcoinHome())),
            content: [Result(message: 'You sent ${widget.amount_usd}')],
            bumper: Bumper(context, content: [
                CustomButton(
                    txt: 'Done', 
                    variant: 'secondary', 
                    onTap: () {resetNavTo(context, BitcoinHome());},
                ),
            ]),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}
