import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:orange/components/numeric_keypad.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';
//import 'package:orange/global.dart' as global;

class Amount extends GenericWidget {
  Amount({super.key});

  String min = ''; //formatValue(min)
  String max = ''; //formatValue(max)
  int minUnformatted = 0; //min amount to send
  int maxUnformatted = 0; // max amount to send
  double btc = 0; //btc //double parsed = double.parse(amount); return parsed > 0 ? (parsed / widget.globalState.state.value.currentPrice) : 0.0;

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
      widget.min;
      widget.max;
      widget.minUnformatted;
      widget.maxUnformatted;
      widget.btc;
    });
  }

  String amount = "0";
  String error = "";
  onContinue(double btc) {
    navigateTo(
      context,
      Speed(),
    );
  }

  isValid(String input) {} //This needs to be a backend function that checks if the input is valid.

  void updateAmount(String input) {
    var buzz = FeedbackType.warning;
    var err = "";

    HapticFeedback.heavyImpact();

    var updatedAmount = "0";
    if (isValid(input)) {
      updatedAmount = amount;
    } else {
      Vibrate.feedback(buzz);
      _shakeController.shake();
    }

    if (double.parse(updatedAmount) != 0) {
      if (double.parse(updatedAmount) <= widget.minUnformatted) err = "\$${widget.min} minimum.";
      if (double.parse(updatedAmount) > widget.maxUnformatted) err = "\$${widget.max} maximum.";
      if (err == "\$0.00 maximum.") err = "You have no bitcoin.";
    } else {
      err = '';
    }
    setState(() {
      amount = updatedAmount;
      error = err;
    });
  }

  final ShakeController _shakeController = ShakeController();

  @override
  Widget build(BuildContext context) {
    String enabled = amount != "0" && error == "" ? 'enabled' : 'disabled';

    return Stack_Default(
      Header_Stack(context, "Send bitcoin"),
      [
        Expanded(
          child: Center(
            child: ShakeWidget(
              controller: _shakeController,
              child: keyboardAmountDisplay(context, amount, widget.btc, error),
            ),
          ),
        ),
      ],
      Bumper(
        context,
        [
          NumericKeypad(
            onNumberPressed: updateAmount,
          ),
          CustomButton('Continue', 'primary lg $enabled expand none', () => onContinue(widget.btc), key: UniqueKey())
        ],
        true,
      ),
      Alignment.topCenter,
      false,
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

    displayDecimals(amt) {
      int decimals = amt.contains(".") ? amt.split(".")[1].length : 0;
      if (decimals == 0 && amt.contains(".")) {
        return '00';
      } else if (decimals == 1) {
        return '0';
      } else {
        return '';
      }
    }

    String valueUSD = '0';
    String x = '';
    if (usd.contains('.')) x = usd.split(".")[1];
    if (usd.contains('.') && x.isEmpty) {
      valueUSD = NumberFormat("#,###", "en_US").format(double.parse(usd));
      valueUSD += '.';
    } else if (usd.contains('.') && x.isNotEmpty) {
      valueUSD = NumberFormat("#,###", "en_US").format(double.parse(usd.split('.')[0]));
      valueUSD += '.$x';
    } else {
      valueUSD = NumberFormat("#,###", "en_US").format(double.parse(usd));
    }

    var length = usd.length;
    if (usd.contains('.')) length - 1;
    length = usd.length + displayDecimals(usd).length;

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
                CustomText('heading $size', "\$$valueUSD"),
                CustomText('heading $size text_secondary', displayDecimals(usd)),
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
