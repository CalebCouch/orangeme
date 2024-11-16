import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
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
            children: keys.map((number) => Key(number: number, onPressed: onNumberPressed)).toList(),
        );
    }
}

class Key extends StatelessWidget {
    final KeyPress number;
    final void Function(KeyPress) onPressed;

    const Key({
        required this.number,
        required this.onPressed,
    });

    @override
    Widget build(BuildContext context) {
        var txt = number == KeyPress.decimal ? '.' : number.index.toString();

        return InkWell(
        onTap: () => onPressed(number),
            child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(AppPadding.bumper),
                alignment: Alignment.center,
                height: 48,
                child: number == KeyPress.backspace ? deleteButton(context) : numberButton(context, txt),
            ),
        );
    }
}
