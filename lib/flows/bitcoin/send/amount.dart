import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:orange/components/amount_display.dart';
import 'package:orange/components/numeric_keypad.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orangeme_material/orangeme_material.dart';

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

  double getBTC(amount) {
    double parsed = double.parse(amount);
    return parsed > 0 ? (parsed / widget.globalState.state.value.currentPrice) : 0.0;
  }

  final ShakeController _shakeController = ShakeController();
  Widget buildScreen(BuildContext context, DartState state) {
    return SimpleKeyboardListener(
      onPressed: (String input) => updateAmount(widget.globalState, error, input, amount, _shakeController),
      child: Stack_Default(
        Header_Stack(context, "Bitcoin address"),
        [
          AmountDisplay(amount, getBTC(amount)),
          NumericKeypad(
            onNumberPressed: (String input) => updateAmount(widget.globalState, error, input, amount, _shakeController),
          ),
        ],
        Bumper(
          [
            CustomButton(
              'Confirm',
              'primary lg  ${(amount != "0" && error == "") ? 'enabled' : 'disabled'} expand none',
              () => onContinue(getBTC(amount)),
            )
          ],
        ),
      ),
    );
  }

//The following widgets can ONLY be used in this file

  Widget BalanceDisplay(DartState state) {
    dynamic_size(x) {
      if (x <= 4) return 'title';
      if (x <= 7) return 'h1';
      return 'h2';
    }

    String usd = state.usdBalance == 0 ? "\$0.00" : "\$${formatValue(state.usdBalance)}";

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: AppPadding.valueDisplay),
      child: CustomColumn([
        CustomText(
          'heading ${dynamic_size(formatValue(state.usdBalance).length)}',
          '$usd USD',
        ),
        CustomText('text lg text_secondary', '${formatBTC(state.btcBalance, 8)} BTC')
      ], AppPadding.valueDisplaySep),
    );
  }

  Widget AmountDisplay(amt, btc) {
    String usd = amt.toString();

    Widget subText(String error) {
      if (error.isNotEmpty) {
        return Row(
          children: [const CustomIcon('error md danger'), const SizedBox(width: 8), CustomText('text lg danger', error)],
        );
      } else if (true && amt == "0") {
        //onDesktop only
        return const CustomText('text lg textSecondary', "Type dollar amount.");
      } else {
        return CustomText('text lg textSecondary', "${formatBTC(btc, 8)} BTC");
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

    dynamic_size(x) {
      if (x <= 4) return 'title';
      if (x <= 7) return 'h1';
      return 'h2';
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: CustomColumn([
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText('heading ${dynamic_size(text_size)}', "\$$valueUSD"),
            CustomText('heading ${dynamic_size(text_size)}, textSecondary', displayDecimals(usd))
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
}
