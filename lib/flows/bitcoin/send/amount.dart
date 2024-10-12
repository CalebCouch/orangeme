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

    var updatedAmount = "0";
    if (isValid(input)) {
      updatedAmount = amount;
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

  Widget display() {
    return Expanded(
      child: Center(
        child: ShakeWidget(
          controller: _shakeController,
          child: keyboardAmountDisplay(context, amount, widget.btc, error),
        ),
      ),
    );
  }

  Widget keyboardAmountDisplay(BuildContext context, String amt, double btc, String error) {
    String usd = amt.toString();

    Widget subText(String error) {
      if (error.isNotEmpty) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [const CustomIcon('error md danger'), const SizedBox(width: 8), CustomText('text lg danger', error)],
        );
      } else {
        return CustomText('text lg text_secondary', "${formatBTC(btc, 8)} BTC");
      }
    }

    var length = widget.usd.length;
    if (usd.contains('.')) length - 1;

    dynamic_size() {
      if (length <= 4) return 'title';
      if (length <= 7) return 'h1';
      return 'h2';
    }

    String size = dynamic_size();
    return FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText('heading $size', widget.usd),
                CustomText('heading $size text_secondary', widget.decimals),
              ],
            ),
            subText(error)
          ],
        ));
  }
}

class ShakeController extends ChangeNotifier {
  void shake() => notifyListeners();
}

class SimpleKeyboardListener extends StatefulWidget {
  final void Function(String) onPressed;
  final Widget child;

  const SimpleKeyboardListener({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<SimpleKeyboardListener> createState() => _SimpleKeyboardListenerState();
}

class _SimpleKeyboardListenerState extends State<SimpleKeyboardListener> {
  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    if (event is KeyDownEvent) {
      if (isNumeric(key)) {
        widget.onPressed(key);
      }
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        widget.onPressed('backspace');
      }
      if (event.logicalKey == LogicalKeyboardKey.period) {
        widget.onPressed('.');
      }
    }

    return false;
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
