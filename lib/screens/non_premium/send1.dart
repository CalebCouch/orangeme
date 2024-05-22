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
  bool isButtonEnabled = false;

  void _updateAmount(String input) {
    //determine the max amount the user can input in dollar terms
    // double maxDollarAmount = (widget.balance / 100000000) * widget.price!;
    double maxDollarAmount = 9999999;
    print("Max Dollar Amount to spend: $maxDollarAmount");
    //define a temporary value for parsing user input
    String tempAmount = '0.00';
    //if the user inputs backspace, exclude the input from temp value parse
    if (input.contains("backspace")) {
      print("backspace detected, override input in parse");
      tempAmount = amount;
      //set the temp value to old amount + new input
    } else {
      print("no backspace detected, proceed with standard parse");
      tempAmount = amount + input;
    }
    //if the temp amount is an invalid double, override
    if (tempAmount == "0." ||
        tempAmount == "0.00." ||
        tempAmount == "." ||
        tempAmount == '') {
      print("tempAmount invalid double, override to 0");
      tempAmount = "0.00";
      //if the temp amount contains the backspace string, override
    } else if (tempAmount.contains("backspace")) {
      print("backspace found in tempAmount, override to 0");
      tempAmount = "0.00";
    }
    //establish a substring list to limit decimal places to 0.00
    List<String> parts = [];
    print("Temp Amount: $tempAmount");
    double? inputNull = double.tryParse(input);
    //split the sanitized temp value by the decimal point if it exists
    if (tempAmount.contains(".")) {
      parts = tempAmount.split('.');
      print("parts: $parts");
      //user attempts to enter more than one trailing zero after the decimal, force stop input and terminate
      if (tempAmount == "0.00" && input == "0") {
        setState(() {
          amount = amount;
        });
        evaluateButton(input);
        return;
        //user attempts an input from 0.00 state that would exceed max balance, force stop input and terminate
      } else if (inputNull != null &&
          tempAmount == "0.00" &&
          input != '.' &&
          double.parse(input) > maxDollarAmount) {
        print("**********input would exceed max balance*********");
        evaluateButton(input);
        return;
        //user is attempting to exceed the decimal threshold but can be assumed to be entering a leading whole number from 0.00, proceed with input & terminate
      } else if (tempAmount == "0.00" && input != "backspace" && input != ".") {
        setState(() {
          print("tempAmount 0.00 detected, proceeding with input");
          amount = "$input";
        });
        evaluateButton(input);
        return;
        //user attempts to exceed 2 decimal threshold, force stop input & terminate
      } else if (parts.length == 2 &&
          parts[1].length > 2 &&
          input != "backspace") {
        print("decimal constraint exceeded");
        evaluateButton(input);
        return;
      }
    }
    //standard keyboard inputs
    double? tempAmountNull = double.tryParse(tempAmount);
    setState(() {
      //user deletes the most right character
      if (input == 'backspace') {
        //standard backspace input
        if (amount.length > 1) {
          print("backspace triggered");
          amount = amount.substring(0, amount.length - 1);
          //user attempts to delete an empty field, force stop input
        } else {
          print("backspace triggered, empty");
          amount = "";
        }
        //user attempts to exceed max Balance, force stop input
      } else if (tempAmountNull != null &&
          double.parse(tempAmount) >= maxDollarAmount) {
        print("*********max balance exceeded***********");
        //user inputs values <$1
      } else if (amount == "0.00") {
        //user inputs a decimal, assume they want <$1
        if (input == '.') {
          print("inputting less than a dollar");
          amount = "0.";
          //user inputs a whole number with no decimal prefix, clear the field and accept the input as a leading whole number
        } else {
          print("assuming whole number");
          amount = input;
        }
        //user enters an integer with a leading zero and no decimal, assume whole number and force input
      } else if (amount == "0" && input != ".") {
        print("leading zero, no decimal place, assume whole number");
        amount = input;
        //user attempts to enter more than one leading zero before a decimal, assume user wants <$1 and force input
      } else if (input == "0" && (amount == "0" || amount == "0.00")) {
        print("multiple leading zeros, assume decimal");
        amount = "0.";
        //user provides a standard input not covered above, behaves as expected
      } else if (input == '.' &&
          (amount == '' ||
              amount == "0" ||
              amount == "0.0" ||
              amount == "0.00")) {
        amount = "0.";
      } else {
        print("standard input");
        amount += input;
      }
      evaluateButton(input);
    });
  }

  void evaluateButton(String input) {
    setState(() {
      //user has only 1 character and they input a backspace, disable button
      double? amountNull = double.tryParse(amount);
      if (input.contains("backspace") && amount.length <= 1) {
        print(
            "amount less than 1 character, user deletion input detected, button disabled");
        isButtonEnabled = false;
        //users input results in a value exceeding one penny, enable button (set dust limit here?)
        //threshold is set to 1/100 of a penny due to temp value (amount + input concatenation)'s effect on baseline 0.00, inputs < 0.01 are rejected
      } else if (amountNull != null && double.parse(amount) >= 0.001) {
        print("amount check exceeds one penny, button enabled");
        isButtonEnabled = true;
        //users input does not exceed one penny, disable button
      } else {
        print("amount check failed, button disabled");
        isButtonEnabled = false;
      }
    });
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
            KeyboardValueDisplay(
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
