import 'package:flutter/material.dart';
import 'package:orange/widgets/numberpad.dart';
import 'package:orange/widgets/dashboard_value.dart';
import 'package:orange/widgets/transaction_list.dart';

class Send1 extends StatefulWidget {
  final int balance;
  final double? price;

  const Send1({super.key, required this.balance, required this.price});

  @override
  Send1State createState() => Send1State();
}

class Send1State extends State<Send1> {
  String amount = "\$0.00";

  void _updateAmount(String input) {
    double maxDollarAmount = (widget.balance / 100000000) * widget.price!;
    print("Max Dollar Amount to spend: $maxDollarAmount");
    String tempAmount = amount + input;
    bool tempAmountValid = true;
    List<String> parts = [];
    //check for a valid double parse before max amount exceed check
    if (tempAmount == "\$0." || tempAmount == "\$0.00.") {
      tempAmount = "\$0.00";
    }
    String cleanParse = tempAmount.replaceAll('\$', '');
    //user attempts to exceed 2 decimal threshold
    if (cleanParse.contains(".")) {
      parts = cleanParse.split('.');
      print("parts: $parts");
      if (parts.length == 2 && parts[1].length > 2 && input != "backspace") {
        print("decimal constraint exceeded");
        setState(() {
          amount = amount;
        });
        return;
      }
    }
    setState(() {
      //user deletes the most right character
      if (input == 'backspace') {
        if (amount.length > 2) {
          amount = amount.substring(0, amount.length - 1);
        } else {
          amount = "\$";
        }
        //user attempts to exceed max Balance
      } else if (double.parse(cleanParse) >= maxDollarAmount) {
        print("max balance exceeded");
        amount = amount;
        //user wants to input <$1
      } else if (amount == "\$0.00") {
        if (input == '.') {
          amount = "\$0.";
        } else {
          amount = "\$$input";
        }
        //user enters an integer with a leading zero and no decimal
      } else if (amount == "\$0" && input != ".") {
        amount = "\$$input";
        //user attempts to enter more than one leading zero, assume wants input <$1
      } else if (input == "0" && (amount == "\$0" || amount == "\$0.00")) {
        amount = "\$0.";
        //user provides a standard input not covered above
      } else {
        amount += input;
      }
    });
  }

  String formatDollarsToSats(String amount, double? price) {
    if (amount == "\$" ||
        amount == "\$0.00" ||
        amount == "\$0." ||
        amount == "\$0") {
      return "0.0";
    } else {
      print("formatting...sat qty: $amount price: $price");
      String cleanParse = amount.replaceAll('\$', '');
      print("clean parse: $cleanParse");
      double qty = (double.parse(cleanParse) / price!);
      print("formatted quantity: $qty");
      return qty.abs().toStringAsFixed(8);
    }
  }

  String formatSatsToDollars(int sats, double price) {
    print("formatting...sats: $sats price: $price");
    double amount = (sats / 100000000) * price;
    print("formatted balance: $amount");
    return "${amount >= 0 ? '' : '- '}\$${amount.abs().toStringAsFixed(2)}";
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
            DashboardValue(
              fiatAmount: amount,
              quantity: formatDollarsToSats(amount, widget.price),
            ),
            const SizedBox(height: 10),
            NumberPad(
              onNumberPressed: _updateAmount,
            ),
          ],
        ),
      ),
    );
  }
}
