import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_icon.dart';

class NumericKeypad extends StatelessWidget {
  final void Function(String) onNumberPressed;

  const NumericKeypad({super.key, required this.onNumberPressed});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 2.0,
      shrinkWrap: true,
      children: [
        _getButton(number: '1', onPressed: onNumberPressed),
        _getButton(number: '2', onPressed: onNumberPressed),
        _getButton(number: '3', onPressed: onNumberPressed),
        _getButton(number: '4', onPressed: onNumberPressed),
        _getButton(number: '5', onPressed: onNumberPressed),
        _getButton(number: '6', onPressed: onNumberPressed),
        _getButton(number: '7', onPressed: onNumberPressed),
        _getButton(number: '8', onPressed: onNumberPressed),
        _getButton(number: '9', onPressed: onNumberPressed),
        _getButton(number: '.', onPressed: onNumberPressed),
        _getButton(number: '0', onPressed: onNumberPressed),
        _getButton(number: 'backspace', onPressed: onNumberPressed),
      ],
    );
  }
}

class _getButton extends StatelessWidget {
  final String number;
  final void Function(String) onPressed;

  const _getButton({
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
        child: number == 'backspace'
            ? deleteButton(context)
            : numberButton(context, number),
      ),
    );
  }
}
