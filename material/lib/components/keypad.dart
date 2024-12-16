import 'package:material/material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';

class NumericKeypad extends StatelessWidget {
    final void Function(KeyPress) onNumberPressed;

    const NumericKeypad({super.key, required this.onNumberPressed});

    @override
    Widget build(BuildContext context) {
        final keys = [
            KeyPress.one,
            KeyPress.two,
            KeyPress.three,
            KeyPress.four,
            KeyPress.five,
            KeyPress.six,
            KeyPress.seven,
            KeyPress.eight,
            KeyPress.nine,
            KeyPress.decimal,
            KeyPress.zero,
            KeyPress.backspace,
        ];

        return GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 2.0,
            shrinkWrap: true,
            children: keys.map((number) => KeypadButton(number: number, onPressed: onNumberPressed)).toList(),
        );
    }
}

class KeypadButton extends StatelessWidget {
    final KeyPress number;
    final void Function(KeyPress) onPressed;

    const KeypadButton({
        required this.number,
        required this.onPressed,
    });

    @override
    Widget build(BuildContext context) {
        return InkWell(
        onTap: () => onPressed(number),
            child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(AppPadding.bumper),
                alignment: Alignment.center,
                height: 48,
                child: KeyButton(context, number),
            ),
        );
    }

    Widget KeyButton (BuildContext context, KeyPress number) {
        if (number == KeyPress.decimal) return NumberButton(context, '.');
        if (number == KeyPress.backspace) return DeleteButton(context);
        return NumberButton(context, number.index.toString());
    }
}

// DESKTOP

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
            } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
                widget.onPressed('backspace');
            } else if (event.logicalKey == LogicalKeyboardKey.period) {
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