import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/numeric_keypad.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/util.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:vibration/vibration.dart';

class Amount extends StatefulWidget {
  double balance;
  double price;
  String address;
  Amount(this.balance, this.price, this.address, {super.key});

  @override
  AmountState createState() => AmountState();
}

class AmountState extends State<Amount> {
    final ShakeController _shakeController = ShakeController();
    bool enabled = false;
    String amount = '';
    double btc = 0.0;
    int zeros = 0; 
    bool validation = true;
    String err = '';


    onContinue() {
        BigInt amount = btc*1000000 as BigInt;
        navigateTo(context, Speed(widget.address, amount));
    }

    onDisabled() {
        _shakeController.shake();
        Vibration.vibrate(pattern: [0, 200, 100], intensities: [0, 100, 50]);
    }

    update(String input) {

        HapticFeedback.heavyImpact();
        final (String a, double b, int z, bool v, String e) =
            updateDisplayAmount(amount, widget.balance, widget.price, input) as (String, double, int, bool, String);
        setState((){
            amount = a;
            btc = b;
            zeros = z;
            validation = v;
            err = e;
        });
        if (validation) {
            _shakeController.shake();
            Vibration.vibrate(pattern: [0, 200, 100], intensities: [0, 100, 50]);
        }
    }

    bool isNotZero() {
        return !['0', '0.00', '0.', '0.0'].contains(amount);
    }

    updateButton() {
        setState(() {
            enabled = err == '' && isNotZero();
        });
    }

  @override
  Widget build(BuildContext context) {
    updateButton();
    return Stack_Default(
      Header_Stack(context, "Send bitcoin"),
      [display()],
      Bumper(
        context,
        [
          NumericKeypad(onNumberPressed: update),
          CustomButton('Continue', 'primary lg expand none', onContinue, enabled, onDis: onDisabled),
        ],
        true,
      ),
      Alignment.topCenter,
      false,
    );
  }

  Widget display() {
    return Expanded(
      child: Center(
        child: ShakeWidget(
          controller: _shakeController,
          child: keyboardAmountDisplay(context),
        ),
      ),
    );
  }

  Widget keyboardAmountDisplay(BuildContext context) {
    Widget subText() {
      if (err == '') {
        return CustomText('text lg text_secondary', "${btc.toStringAsFixed(8)} BTC");
      } else {
        return Row(children: [
          const CustomIcon('error md danger'),
          const Spacing(8),
          CustomText('text lg danger', err),
        ]);
      }
    }

    String convert(int x) => x == 1 ? "0" : x == 2 ? "00" : "";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomText('heading title', '\$'),
                CustomText('heading title', amount),
                CustomText('heading title text_secondary', convert(zeros)),
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [subText()],
            ),
          ),
        ],
      ),
    );
  }
}

class ShakeController extends ChangeNotifier {
  void shake() => notifyListeners();
}
