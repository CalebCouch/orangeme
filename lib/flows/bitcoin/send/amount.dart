import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:orange/components/numeric_keypad.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';

class ShakeController extends ChangeNotifier {
  void shake() => notifyListeners();
}

/* Listens for keyboard events and processes numeric inputs, backspace, 
and period key presses for computer keyboards. */

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

/* Allows users to input and validate the amount of Bitcoin to send. Handles numeric 
input, error display, and transitions to the next step based on the input and validation. */
class SendAmount extends StatefulWidget {
  final GlobalState globalState;
  final String address;
  const SendAmount(
    this.globalState,
    this.address, {
    super.key,
  });

  @override
  SendAmountState createState() => SendAmountState();
}

class SendAmountState extends State<SendAmount> {
  String amount = "0";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  Future<void> onContinue(double btc) async {
    navigateTo(
      context,
      TransactionSpeed(
        widget.globalState,
        widget.address,
        btc,
      ),
    );
  }

  /* Updates the input amount based on keyboard input, handles backspace, 
  decimal point, and numeric values. Validates the amount against minimum and maximum limits. */
  void updateAmount(String input) {
    var buzz = FeedbackType.warning;
    HapticFeedback.heavyImpact();
    var updatedAmount = "0";
    if (input == "backspace") {
      if (amount.length == 1) {
        updatedAmount = "0";
      } else if (amount.isNotEmpty) {
        updatedAmount = amount.substring(0, amount.length - 1);
      } else {
        Vibrate.feedback(buzz);
        _shakeController.shake();
        updatedAmount = amount;
      }
    } else if (input == ".") {
      if (!amount.contains(".") && amount.length <= 7) {
        updatedAmount = amount += ".";
      } else {
        Vibrate.feedback(buzz);
        _shakeController.shake();
        updatedAmount = amount;
      }
    } else {
      if (amount == "0") {
        updatedAmount = input;
      } else if (amount.contains(".")) {
        if (amount.length < 11 && amount.split(".")[1].length < 2) {
          updatedAmount = amount + input;
        } else {
          Vibrate.feedback(buzz);
          _shakeController.shake();
          updatedAmount = amount;
        }
      } else {
        if (amount.length < 10) {
          updatedAmount = amount + input;
        } else {
          Vibrate.feedback(buzz);
          _shakeController.shake();
          updatedAmount = amount;
        }
      }
    }

    double min = widget.globalState.state.value.fees[0] + 0.10;
    var max = widget.globalState.state.value.usdBalance - min;
    max = max > 0 ? max : 0;
    var err = "";
    if (double.parse(updatedAmount) != 0) {
      if (double.parse(updatedAmount) <= min) {
        err = "\$${formatValue(min)} minimum.";
      } else if (double.parse(updatedAmount) > max) {
        err = "\$${formatValue(max)} maximum.";
        if (err == "\$0 maximum.") {
          err = "You have no bitcoin.";
        }
      }
    }
    setState(() {
      amount = updatedAmount;
      error = err;
    });
  }

  double getBTC(amount) {
    double parsed = double.parse(amount);
    return parsed > 0 ? (parsed / widget.globalState.state.value.currentPrice) : 0.0;
  }

  final ShakeController _shakeController = ShakeController();
  Widget buildScreen(BuildContext context, DartState state) {
    String enabled = amount != "0" && error == "" ? 'enabled' : 'disabled';
    print(enabled);
    return Stack_Default(
      Header_Stack(context, "Send bitcoin"),
      [
        Expanded(
          child: Center(
            child: ShakeWidget(
              controller: _shakeController,
              child: keyboardAmountDisplay(widget.globalState, context, amount, getBTC(amount), error),
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
          CustomButton('Continue', 'primary lg $enabled expand none', () => onContinue(getBTC(amount)), key: UniqueKey())
        ],
        true,
      ),
      Alignment.topCenter,
      false,
    );
  }

  Widget keyboardAmountDisplay(GlobalState globalState, BuildContext context, String amt, double btc, String error) {
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


/*
else if (false && amt == "0") {
        //onDesktop
        return const CustomText('text lg text_secondary', 'Type dollar amount.');
      } */