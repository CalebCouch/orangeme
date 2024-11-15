import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orangeme_material/orangeme_material.dart';

class NumericKeypad extends StatelessWidget {
    final void Function(String) onNumberPressed;

    const NumericKeypad({super.key, required this.onNumberPressed});

    @override
    Widget build(BuildContext context) {
        final keys = [
            '1', '2', '3',
            '4', '5', '6',
            '7', '8', '9',
            '.', '0', 'backspace',
        ];

        return GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 2.0,
            shrinkWrap: true,
            children: keys.map((key) => Key(number: key, onPressed: onNumberPressed)).toList(),
        );
    }
}

class Key extends StatelessWidget {
    final String number;
    final void Function(String) onPressed;

    const Key({
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
                child: number == 'backspace' ? deleteButton(context) : numberButton(context, number),
            ),
        );
    }
}
