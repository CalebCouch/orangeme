import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/numeric_keypad.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/global.dart' as global;

class Amount extends GenericWidget {
  Amount({super.key});

  String err = '';
  double btc = 0;
  String amount = '0';
  String decimals = '0';

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
      widget.btc = json["btc"];
      widget.err = json["err"];
      widget.amount = json["amount"];
      widget.decimals = json["decimals"];
    });
  }

  @override
  initState() {
    super.initState();
    updateDisplayAmount(path: global.dataDir!, input: "reset");
  }

  final ShakeController _shakeController = ShakeController();
  String enabled = 'disabled';

  onContinue() {
    //setStateBitcoin(path: global.dataDir!, amount: widget.amount);
    navigateTo(Speed());
  }

  onDisabled() {
    _shakeController.shake();
  }

  void update(String input) {
    HapticFeedback.heavyImpact();
    var valid = updateDisplayAmount(path: global.dataDir!, input: input);
    if (valid == 'false') _shakeController.shake();
  }

  updateButton() {
    setState(() {
      enabled = widget.err == '' && widget.amount != '0' ? 'enabled' : 'disabled';
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
          child: keyboardAmountDisplay(context, widget.amount, widget.btc, widget.err),
        ),
      ),
    );
  }

  Widget keyboardAmountDisplay(BuildContext context, String amt, double btc, String error) {
    Widget subText() {
      if (error == '') {
        return CustomText('text lg text_secondary', "$btc BTC");
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
                CustomText('heading title text_secondary', widget.decimals),
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
