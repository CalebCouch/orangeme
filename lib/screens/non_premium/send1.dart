import 'package:flutter/material.dart';
import 'package:orange/widgets/numberpad.dart';
import 'package:orange/widgets/value_display.dart';
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
  String amount = "0.00";
  bool isButtonEnabled = false;

  void _updateAmount(String input) {
    double maxDollarAmount = (widget.balance / 100000000) * widget.price!;
    print("Max Dollar Amount to spend: $maxDollarAmount");
    String tempAmount = amount;
    // Handle backspace
    if (input == "backspace") {
      if (tempAmount.length > 1) {
        tempAmount = tempAmount.substring(0, tempAmount.length - 1);
      } else {
        tempAmount = "0.00";
      }
    } else {
      // Prevent multiple leading zeros
      if (tempAmount == "0.00") {
        tempAmount = input == "." ? "0." : input;
      } else {
        tempAmount += input;
      }
    }
    // Ensure tempAmount is a valid dollar amount
    if (!RegExp(r"^\d*\.?\d{0,2}$").hasMatch(tempAmount)) {
      return;
    }
    // Limit the amount to maxDollarAmount
    double? tempAmountDouble = double.tryParse(tempAmount);
    if (tempAmountDouble != null && tempAmountDouble > maxDollarAmount) {
      return;
    }
    setState(() {
      amount = tempAmount;
      evaluateButton();
    });
  }

  void evaluateButton() {
    double? amountDouble = double.tryParse(amount);
    if (amountDouble != null && amountDouble >= 0.01) {
      isButtonEnabled = true;
    } else {
      isButtonEnabled = false;
    }
  }

  String formatDollarsToSats(String amount, double? price) {
    if (amount == "" || amount == "0.00" || amount == "0." || amount == "0") {
      return "0.00000000";
    } else {
      print("formatting...sat qty: $amount price: $price");
      double? qtyNull = double.tryParse(amount);
      if (qtyNull != null) {
        double qty = (double.parse(amount) / price!);
        print("formatted quantity: $qty");
        return qty.abs().toStringAsFixed(8);
      } else {
        return "0.00000000";
      }
    }
  }

  void onContinue() {
    String qty = formatDollarsToSats(amount, widget.price);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Send2(amount: double.parse(qty))));
  }

  @override
  Widget build(BuildContext context) {
    print("Price: ${widget.price}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Send Bitcoin'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueDisplay(
              fiatAmount: amount == '' ? '0' : amount,
              quantity: amount == ''
                  ? formatDollarsToSats('0', widget.price)
                  : formatDollarsToSats(amount, widget.price),
            ),
            const SizedBox(height: 10),
            NumberPad(
              onNumberPressed: _updateAmount,
            ),
            const SizedBox(height: 15),
            ButtonOrangeLG(
              label: "Continue",
              onTap: () => onContinue(),
              isEnabled: isButtonEnabled,
            ),
          ],
        ),
      ),
    );
  }
}
