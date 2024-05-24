import 'package:flutter/material.dart';
import 'package:orange/widgets/numberpad.dart';
import 'package:orange/widgets/keyboard_value_display.dart';
import 'package:orange/screens/non_premium/send2.dart';
import 'package:orange/components/buttons/orange_lg.dart';

class Send1 extends StatefulWidget {
  final int balance;
  final double? price;

  const Send1({super.key, required this.balance, required this.price});

  @override
  Send1State createState() => Send1State();
}

class Send1State extends State<Send1> {
  String amount = "0";
  final GlobalKey<KeyboardValueDisplayState> _displayKey =
      GlobalKey<KeyboardValueDisplayState>();
  bool isButtonEnabled = false;

  //algorithim used to control the logic of the virtual keyboard
  void _updateAmount(String input) {
    // double maxDollarAmount = (widget.balance / 100000000) * widget.price!;
    double maxDollarAmount = 99999999999;
    String tempAmount = amount; // Currently displayed amount

    if (input == "backspace") {
      // When input is backspace, handle deletion
      if (tempAmount.length > 1) {
        tempAmount = tempAmount.substring(0, tempAmount.length - 1);
        //if tempAmount becomes empty after backspacing, reset to 0
        if (tempAmount == "" || tempAmount == "0") {
          tempAmount = "0";
        }
        //default to 0 catchall
      } else {
        tempAmount = "0";
      }
    } else {
      if (tempAmount == "0.00" || tempAmount == "0") {
        // Avoid leading zero unless entering a decimal
        tempAmount = (input == ".") ? "0." : input;
      } else {
        // prevent leading zeroes in whole numbers
        if (tempAmount == "0" && input != "." && tempAmount != "0.") {
          tempAmount = input; // Replace leading zero
        } else {
          tempAmount += input;
        }
      }
    }
    // Ensure tempAmount is a valid dollar amount with at most two decimal places
    if (!RegExp(r"^\d*\.?\d{0,2}$").hasMatch(tempAmount)) {
      _displayKey.currentState?.shake();
      return; // Return if not a valid format
    }
    // Convert tempAmount to a double and check it doesn't exceed max amount
    double? tempAmountDouble = double.tryParse(tempAmount);
    if (tempAmountDouble != null && tempAmountDouble > maxDollarAmount) {
      _displayKey.currentState?.shake();
      return; // Prevent exceeding the maximum amount
    }
    setState(() {
      amount = tempAmount;
      evaluateButton();
    });
  }

  //evalute if the send button should be activated
  void evaluateButton() {
    double? amountDouble = double.tryParse(amount);
    if (amountDouble != null && amountDouble >= 0.01) {
      isButtonEnabled = true;
    } else {
      isButtonEnabled = false;
    }
  }

  //format a number of satoshis into dollars at the last known exchange rate
  String formatDollarsToBTC(String amount, double? price, bool satsFormat) {
    if (!satsFormat) {
      print("sats format false, giving decimal format");
      if (amount == "" || amount == "0.00" || amount == "0." || amount == "0") {
        return "0.00000000";
      } else {
        print("formatting...USD qty: $amount price: $price");
        double? qtyNull = double.tryParse(amount);
        if (qtyNull != null) {
          double qty = (double.parse(amount) / price!);
          print("formatted quantity: $qty");
          return qty.abs().toStringAsFixed(8);
        } else {
          return "0.00000000";
        }
      }
    } else {
      print("sats format true, giving sats format");
      if (amount == "" || amount == "0.00" || amount == "0." || amount == "0") {
        return "0";
      } else {
        print("formatting...USD qty: $amount price: $price");
        double qty = (double.parse(amount) / price!);
        print("sats quantity: $qty");
        double sats = (qty * 100000000);
        print("formatted quantity: $sats");
        return sats.round().toString();
      }
    }
  }

  //used to navigate to the next page in the send flow
  void onContinue() {
    int qty = int.parse(formatDollarsToBTC(amount, widget.price, true));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Send2(amount: qty, balance: widget.balance)));
  }

  @override
  Widget build(BuildContext context) {
    print("Price: ${widget.price}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Send Bitcoin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            KeyboardValueDisplay(
              key: _displayKey,
              fiatAmount: amount == '' ? '0' : amount,
              quantity: amount == ''
                  ? formatDollarsToBTC('0', widget.price, false)
                  : formatDollarsToBTC(amount, widget.price, false),
              onShake: () {},
            ),
            NumberPad(
              onNumberPressed: _updateAmount,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ButtonOrangeLG(
          label: "Send",
          onTap: () => onContinue(),
          isEnabled: isButtonEnabled,
        ),
      ),
    );
  }
}
