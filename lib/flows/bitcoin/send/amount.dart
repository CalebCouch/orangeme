import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:orange/components/numeric_keypad.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/global.dart' as global;

class Amount extends GenericWidget {
  final String address;
  Amount({super.key, required this.address});

  String err = '';
  double btc = 0;
  String amount = '0';
  String decimals = '0';
  bool validation = false;

  @override
  AmountState createState() => AmountState();
}

class AmountState extends GenericState<Amount> {
  @override
  String stateName() {
    return "Amount";
  }

  @override
  int refreshInterval() {
    return 100;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
      //print('setting state');
      widget.btc;
      widget.err = json["err"];
      widget.amount = json["amount"];
      widget.decimals = json["decimals"];
      widget.validation = json["validation"] as bool;
    });
  }

  @override
  initState() {
    super.initState();
    updateDisplayAmount(path: global.dataDir!, input: "reset");
  }

  final ShakeController _shakeController = ShakeController();

  onContinue() {
    navigateTo(Speed(address: widget.address, btc: toBitcoin(widget.amount)));
  }

  void update(String input) {
    HapticFeedback.heavyImpact();
    updateDisplayAmount(path: global.dataDir!, input: input);
    print(widget.amount);
    print(widget.validation);
    if (!widget.validation) _shakeController.shake();
  }

  @override
  Widget build(BuildContext context) {
    String enabled = widget.validation && widget.err == "" && widget.amount != '0' ? 'enabled' : 'disabled';
    return Stack_Default(
      Header_Stack(context, "Send bitcoin"),
      [display()],
      Bumper(
        context,
        [
          NumericKeypad(onNumberPressed: update),
          CustomButton('Continue', 'primary lg $enabled expand none', onContinue, key: UniqueKey()),
        ],
        true,
      ),
      Alignment.topCenter,
      false,
    );
  }

  toBitcoin(String amt) {
    return 0.000005; //to bitcoin
  }

  Widget display() {
    return Expanded(
      child: Center(
        child: ShakeWidget(
          controller: _shakeController,
          child: keyboardAmountDisplay(context, widget.amount, toBitcoin(widget.amount), widget.err),
        ),
      ),
    );
  }

  Widget keyboardAmountDisplay(BuildContext context, String amt, double btc, String error) {
    Widget subText() {
      return Row(children: [
        if (error.isNotEmpty) ...[
          const CustomIcon('error md danger'),
          const Spacing(8),
          CustomText('text lg danger', error),
        ] else
          CustomText('text lg text_secondary', "$btc BTC"),
      ]);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText('heading title', amt),
              CustomText('heading title text_secondary', widget.decimals),
            ],
          ),
          subText()
        ]),
      ),
    );
  }
}

class ShakeController extends ChangeNotifier {
  void shake() => notifyListeners();
}
