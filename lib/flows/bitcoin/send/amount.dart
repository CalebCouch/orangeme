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

    @override
    Widget build(BuildContext context) {
        setState(() { enabled = err == '' && isNotZero(); });

        return Stack_Default(
            header: Header_Stack(context, "Send bitcoin"),
            content: [display()],
            bumper: Bumper(
                context,
                content: [
                    NumericKeypad(onNumberPressed: update),
                    CustomButton(
                        txt: 'Continue',
                        onTap: onContinue, 
                        enabled: enabled, 
                        onDis: onDisabled
                    ),
                ],
                vertical: true,
            ),
            alignment: Alignment.topCenter,
            scroll: false,
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
                    const CustomIcon(icon: 'error', size: 'md', color: 'danger'),
                    const Spacing(8),
                    CustomText(variant: 'text', font_size: 'lg', text_color: 'danger', txt: err),
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
                                const CustomText(
                                    variant: 'heading', 
                                    font_size: 'title', 
                                    txt: '\$'
                                ),
                                CustomText(
                                    variant: 'heading', 
                                    font_size: 'title', 
                                    txt: amount
                                ),
                                CustomText(
                                    variant: 'heading', 
                                    font_size: 'title', 
                                    text_color: 'text_secondary', 
                                    txt:convert(zeros)
                                ),
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
