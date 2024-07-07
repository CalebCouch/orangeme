import 'package:flutter/material.dart';
import 'package:orange/components/list_selector/radio_list_selector.dart';
import 'package:orange/theme/stylesheet.dart';

class TransactionSpeedSelector extends StatefulWidget {
  const TransactionSpeedSelector({
    super.key,
  });
  @override
  State<TransactionSpeedSelector> createState() => TransactionState();
}

class TransactionState extends State<TransactionSpeedSelector> {
  var priorityFee = 3.14;
  var standardFee = 5.45;
  int value = 0;
  List<String> currentIcon = [ThemeIcon.radioFilled, ThemeIcon.radio];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              value = 0;
            });
          },
          child: RadioListSelector(
            title: "Priority",
            subtitle:
                "Arrives in ~30 minutes\n\$$priorityFee bitcoin network fee",
            icon: (value == 0) ? currentIcon[0] : currentIcon[1],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              value = 1;
            });
          },
          child: RadioListSelector(
            title: "Standard",
            subtitle: "Arrives in ~2 hours\n\$$standardFee bitcoin network fee",
            icon: (value == 1) ? currentIcon[0] : currentIcon[1],
          ),
        ),
      ],
    );
  }
}
