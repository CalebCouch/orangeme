import 'package:flutter/material.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/generic.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/components/result.dart';

class Success extends StatefulWidget {
    late String walletName;
    Success(this.walletName, {super.key});

    @override
    SuccessState createState() => SuccessState();
}

class SuccessState extends State<Success> {
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Wallet created", left: ExitButton(context, 3)),
            content: [Result(message: '${widget.walletName} successfully created', icon: 'wallet')],
            bumper: Bumper(context, content: [CustomButton(txt: 'Done', variant: 'secondary', onTap: () {resetNavTo(context, 3);})]),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}
