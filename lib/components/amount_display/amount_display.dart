import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';

class AmountDisplay extends StatefulWidget {
  final int value;

  const AmountDisplay({
    super.key,
    required this.value,
  });

  @override
  State<AmountDisplay> createState() => _AmountDisplayState();
}

class _AmountDisplayState extends State<AmountDisplay> {
  String accountBalance = "";

  _getValueDisplaySize(int value) {
    accountBalance = widget.value.toString();
    if (accountBalance.length <= 4) {
      //1-4
      return TextSize.title;
    } else if (accountBalance.length >= 5 && accountBalance.length <= 7) {
      //5-7
      return TextSize.h1;
    } else {
      // 8-10
      return TextSize.h2;
    }
  }

  _getValueConverted(int value) {
    return "0.46713414"; //needs to return value converted to btc
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.valueDisplay),
      child: Column(
        children: [
          CustomText(
            textType: "heading",
            text: "\$${widget.value}",
            textSize: _getValueDisplaySize(widget.value),
            color: ThemeColor.heading,
          ),
          const Spacing(height: AppPadding.valueDisplaySep),
          CustomText(
            textType: "text",
            text: "${_getValueConverted(widget.value)} BTC",
            textSize: TextSize.lg,
            color: ThemeColor.textSecondary,
          ),
        ],
      ),
    );
  }
}
