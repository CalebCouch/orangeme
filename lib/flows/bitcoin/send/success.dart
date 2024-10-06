import 'package:flutter/material.dart';
import 'package:orange/components/result.dart';

import 'package:orange/flows/bitcoin/home.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'package:orangeme_material/orangeme_material.dart';

class Confirmation extends StatefulWidget {
  final double amount;
  final GlobalState globalState;
  const Confirmation(this.globalState, this.amount, {super.key});

  @override
  ConfirmationState createState() => ConfirmationState();
}

class ConfirmationState extends State<Confirmation> {
  final TextEditingController recipientAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  onDone() {
    () {
      resetNavTo(
        context,
        BitcoinHome(widget.globalState),
      );
    };
  }

  Widget buildScreen(BuildContext context, DartState state) {
    return Stack_Default(
      Header_Stack(context, "Confirm send", exitButton(context, BitcoinHome(widget.globalState))),
      [
        Result('You sent \$${formatValue(widget.amount.abs())}'),
      ],
      Bumper(
        [CustomButton('Done', 'secondary lg enabled expand none', onDone)],
      ),
    );
  }
}
