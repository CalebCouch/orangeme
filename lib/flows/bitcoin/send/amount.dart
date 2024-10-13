import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:orange/components/numeric_keypad.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';
//import 'package:orange/global.dart' as global;

class Amount extends GenericWidget {
  final String address;
  Amount({super.key, required this.address});

  String err = ''; //Displays error if input exceeds min or max
  double btc = 0;
  double inputAmount = 0; // 10.54
  String usd = '0'; // '$10.54'
  String decimals = '0'; // '0' '00' or ''

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
    return 0;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
      widget.btc;
      widget.usd;
      widget.inputAmount;
      widget.decimals;
    });
  }

  String amount = "0";
  String error = "";
  onContinue() {
    navigateTo(Speed(address: widget.address, btc: widget.btc));
  }

  isValid(String input) {} //This needs to be a backend function that checks if the input is valid.

  void updateAmount(String input) {
    var buzz = FeedbackType.warning;
    HapticFeedback.heavyImpact();
    String updatedAmount = amount;

    if (isValid(input)) {
      updatedAmount += input;
    } else {
      Vibrate.feedback(buzz);
      _shakeController.shake();
    }

    setState(() {
      amount = updatedAmount;
    });
  }

  final ShakeController _shakeController = ShakeController();

  @override
  Widget build(BuildContext context) {
    String enabled = amount != "0" && error == "" ? 'enabled' : 'disabled';

    return Stack_Default(
      Header_Stack(context, "Send bitcoin"),
      [display()],
      Bumper(
        context,
        [
          NumericKeypad(onNumberPressed: updateAmount),
          CustomButton('Continue', 'primary lg $enabled expand none', () => onContinue(), key: UniqueKey())
        ],
        true,
      ),
      Alignment.topCenter,
      false,
    );
  }

  toBitcoin(String amt) {
    return amt; //to bitcoin
  }

  Widget display() {
    return Expanded(
      child: Center(
        child: ShakeWidget(
          controller: _shakeController,
          child: keyboardAmountDisplay(context, amount, toBitcoin(amount), error),
        ),
      ),
    );
  }

  Widget keyboardAmountDisplay(BuildContext context, String amt, double btc, String error) {
    Widget subText(String error) {
      return Row(children: [
        if (error.isNotEmpty) ...[
          const CustomIcon('error md danger'),
          const SizedBox(width: 8),
          CustomText('text lg danger', error),
        ] else
          CustomText('text lg text_secondary', "${formatBTC(btc, 8)} BTC"),
      ]);
    }

    dynamic_size() {
      var length = amt.contains('.') ? amt.length - 1 : amt.length;
      if (length <= 4) return 'title';
      if (length <= 7) return 'h1';
      return 'h2';
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText('heading ${dynamic_size()}', widget.usd),
            CustomText('heading ${dynamic_size()} text_secondary', widget.decimals),
          ],
        ),
        subText(error)
      ]),
    );
  }
}

class ShakeController extends ChangeNotifier {
  void shake() => notifyListeners();
}
