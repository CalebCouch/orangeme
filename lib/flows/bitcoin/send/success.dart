import 'package:flutter/material.dart';
import 'package:orange/components/result.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';

//import 'package:orange/global.dart' as global;

class Success extends GenericWidget {
  final ExtTransaction tx;
  Success({super.key, required this.tx});

  double amount = 0; //transaction total

  @override
  SuccessState createState() => SuccessState();
}

class SuccessState extends GenericState<Success> {
  @override
  String stateName() {
    return "Success";
  }

  @override
  int refreshInterval() {
    return 0;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
      widget.amount;
    });
  }

  onDone() {
    resetNavTo(
      context,
      BitcoinHome(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack_Default(
      Header_Stack(context, "Confirm send", exitButton(context, BitcoinHome())),
      [
        Result('You sent ${widget.tx.tx.tx.usd}'),
      ],
      Bumper(context, [CustomButton('Done', 'secondary lg enabled expand none', onDone)]),
      Alignment.center,
      false,
    );
  }
}
