import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/numeric_keypad.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:vibration/vibration.dart';
import 'package:orange/src/rust/api/pub_structs.dart';

class Amount extends GenericWidget {
    String address;
    Amount(this.address, {super.key});

    String amount = "";
    String amount_btc = "";
    int needed_placeholders = 0; 
    bool valid_input = true;
    String? err;
    KeyPress? input;

    AmountState createState() => AmountState();
}

class AmountState extends GenericState<Amount> {
    final ShakeController _shakeController = ShakeController();
    @override

    PageName getPageName() {
        return PageName.amount(widget.amount, widget.input);
    }

    @override
    int refreshInterval() {
        return 1;
    }

    @override
    void unpack_state(Map<String, dynamic> json) {
        setState(() {
            widget.amount = json["amount"] as String;
            widget.amount_btc = json["amount_btc"] as String;
            widget.needed_placeholders = json["needed_placeholders"] as int;
            widget.valid_input = json["valid_input"] as bool;
            widget.err = json["err"] as String?;
            widget.input = null;

            vibrate();
        });
    }

    onContinue() {
       // navigateTo(context, Speed(widget.address, amount));
    }

    onDisabled() {
        _shakeController.shake();
        Vibration.vibrate(pattern: [0, 200, 100], intensities: [0, 100, 50]);
    }

    vibrate() {
        if (widget.valid_input) {
            _shakeController.shake();
            Vibration.vibrate(pattern: [0, 200, 100], intensities: [0, 100, 50]);
        }
    }

    update(KeyPress input) {
        setState(() {
            widget.input = input;
        });
        HapticFeedback.heavyImpact();
    }

    @override
    Widget build_with_state(BuildContext context) {
        var enabled = widget.err == null &&!['0', '0.00', '0.', '0.0'].contains(widget.amount);

        return Stack_Default(
            header: Header_Stack(context, "Send bitcoin"),
            content: [InputDisplay(context)],
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

    Widget InputDisplay(BuildContext context) {
        String convert(int x) => x == 1 ? "0" : x == 2 ? "00" : "";

        return Expanded (
            child: Center(
                child: ShakeWidget(
                    controller: _shakeController,
                    child: Container(
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
                                            CustomText(
                                                variant: 'heading', 
                                                font_size: 'title', 
                                                txt: "\$${widget.amount}"
                                            ),
                                            CustomText(
                                                variant: 'heading', 
                                                font_size: 'title', 
                                                text_color: 'text_secondary', 
                                                txt:convert(widget.needed_placeholders)
                                            ),
                                        ],
                                    ),
                                ),
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: widget.err == null ? [
                                             CustomText(
                                                variant: 'text',
                                                font_size: 'lg',
                                                text_color: 'text_secondary',
                                                txt: widget.amount_btc,
                                            ),
                                        ] : [
                                            const CustomIcon(
                                                icon: 'error',
                                                size: 'md',
                                                color: 'danger',
                                            ),
                                            const Spacing(8),
                                            CustomText(
                                                variant: 'text',
                                                font_size: 'lg',
                                                text_color: 'danger',
                                                txt: widget.err!,
                                            ),
                                        ],
                                    ),
                                ),
                            ],
                        ),
                    ),
                ),
            )
        );
    }
}

class ShakeController extends ChangeNotifier {
    void shake() => notifyListeners();
}
