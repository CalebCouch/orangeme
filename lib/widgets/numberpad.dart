import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/styles/constants.dart';

class NumberPad extends StatelessWidget {
  final void Function(String) onNumberPressed;

  NumberPad({required this.onNumberPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 2.0,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          shrinkWrap: true,
          children: [
            NumberButton(number: '1', onPressed: onNumberPressed),
            NumberButton(number: '2', onPressed: onNumberPressed),
            NumberButton(number: '3', onPressed: onNumberPressed),
            NumberButton(number: '4', onPressed: onNumberPressed),
            NumberButton(number: '5', onPressed: onNumberPressed),
            NumberButton(number: '6', onPressed: onNumberPressed),
            NumberButton(number: '7', onPressed: onNumberPressed),
            NumberButton(number: '8', onPressed: onNumberPressed),
            NumberButton(number: '9', onPressed: onNumberPressed),
            NumberButton(number: '.', onPressed: onNumberPressed),
            NumberButton(number: '0', onPressed: onNumberPressed),
            NumberButton(
              svgIcon: AppIcons.back,
              onPressed: onNumberPressed,
              number: 'backspace',
            ),
          ],
        ),
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final String number;
  final String? svgIcon;
  final void Function(String) onPressed;

  NumberButton({required this.number, this.svgIcon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onPressed(number),
        borderRadius: BorderRadius.zero,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          height: 48,
          child: svgIcon != null
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    svgIcon!,
                    color: AppColors.white,
                  ),
                )
              : Text(
                  number,
                  style: AppTextStyles.textLG.copyWith(color: AppColors.white),
                ),
        ),
      ),
    );
  }
}

