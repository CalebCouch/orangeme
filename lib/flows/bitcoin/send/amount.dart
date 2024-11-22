import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/numeric_keypad.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:vibration/vibration.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/src/rust/api/utils.dart';
import 'package:orange/generic.dart';

class Amount extends GenericWidget {
    String address;
    String amount;
    Amount(this.address, {super.key, this.amount = ''});

    String amount_btc = "";
    BigInt amount_sats = BigInt.from(0);
    int needed_placeholders = 0;
    bool valid_input = true;
    String? err;

    AmountState createState() => AmountState();
}

class AmountState extends GenericState<Amount> {
    final ShakeController _shakeController = ShakeController();
    @override

    PageName getPageName() {
        return PageName.amount(widget.amount);
    }

    @override
    void unpack_state(Map<String, dynamic> json) {
        setState(() {
            widget.amount_btc = json["amount_btc"] as String;
            widget.amount_sats = BigInt.from(json["amount_sats"]);
            widget.err = json["err"] as String?;
        });
    }

    onContinue() {
       navigateTo(context, Speed(widget.address, widget.amount_sats));
    }

    vibrate() {
        _shakeController.shake();
        Vibration.vibrate(pattern: [0, 200, 100], intensities: [0, 100, 50]);
    }

    update(KeyPress input) async {
        HapticFeedback.heavyImpact();
        var (amount, valid_input, np) = await updateAmount(amount: widget.amount, key: input);
        setState(() {
            widget.valid_input = valid_input;
            widget.needed_placeholders = np;
            widget.amount = amount;
        });
        if (!widget.valid_input) {vibrate();}
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
                        onDis: vibrate
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
