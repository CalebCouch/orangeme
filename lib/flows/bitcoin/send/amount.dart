import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/numeric_keypad.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:vibration/vibration.dart';

updateDisplayAmount(String input) {
  //updateDisplayAmount(path: global.dataDir!, input: "reset"); //return amount, decimals, validity, amount btc, error message
  return ("", "12.45");
}

class Amount extends StatefulWidget {
  Amount({super.key});

  @override
  AmountState createState() => AmountState();
}

class AmountState extends State<Amount> {
  dynamic data = ("", "", 0.0, ""); // amount, err, btcAmt, decimals
  final ShakeController _shakeController = ShakeController();
  String enabled = 'disabled';

  onContinue() {
    //setStateBtc(path: global.dataDir!, btc: widget.btc);
    navigateTo(context, Speed());
  }

  onDisabled() {
    _shakeController.shake();
    Vibration.vibrate(pattern: [0, 200, 100], intensities: [0, 100, 50]);
  }

  update(String input) {
    HapticFeedback.heavyImpact();
    var valid = true;
    data = updateDisplayAmount(input);
    if (valid == 'false') {
      _shakeController.shake();
      Vibration.vibrate(pattern: [0, 200, 100], intensities: [0, 100, 50]);
    }
  }

  updateButton() {
    setState(() {
      enabled = data.$1 == '' && data.$0 != '0' ? 'enabled' : 'disabled';
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
          child: keyboardAmountDisplay(context, data.$0, data.$2, data.$1),
        ),
      ),
    );
  }

  Widget keyboardAmountDisplay(BuildContext context, String amt, double btc, String error) {
    Widget subText() {
      if (error == '') {
        return CustomText('text lg text_secondary', "${btc.toStringAsFixed(8)} BTC");
      } else {
        return Row(children: [
          const CustomIcon('error md danger'),
          const Spacing(8),
          CustomText('text lg danger', error),
        ]);
      }
    }

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
                CustomText('heading title', amt),
                CustomText('heading title text_secondary', data.$3),
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
