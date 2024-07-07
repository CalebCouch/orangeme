import 'package:flutter/material.dart';
//import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_header.dart';
import 'package:orange/components/amount_display/keyboard_amount_display.dart';
import 'package:orange/components/interfaces/default_interface.dart';
import 'package:orange/components/bumpers/keypad_bumper.dart';

class SendAmount extends StatefulWidget {
  final int balance;
  final double? price;
  final String? address;
  final String? amount;

  const SendAmount({
    super.key,
    required this.balance,
    required this.price,
    this.address,
    this.amount,
  });

  @override
  SendAmountState createState() => SendAmountState();
}

class SendAmountState extends State<SendAmount> {
  String amount = "0";
  final GlobalKey<KeyboardValueDisplayState> _displayKey =
      GlobalKey<KeyboardValueDisplayState>();
  bool isButtonEnabled = false;
  bool exceedMaxBalance = false;

  //algorithim used to control the logic of the virtual keyboard
  void _updateAmount(String input) {
    print("character is $input");
    double maxDollarAmount = (widget.balance / 100000000) * widget.price!;
    String tempAmount = amount;
    if (input == "backspace") {
      print("found backspace");
      if (tempAmount.length > 1) {
        tempAmount = tempAmount.substring(0, tempAmount.length - 1);
        double? tempAmountDouble = double.tryParse(tempAmount);
        print('accept backspace: new temp amount: $tempAmount');
        if (tempAmountDouble! <= maxDollarAmount && exceedMaxBalance == true) {
          setState(() {
            //reset exceedMaxBalance warning after backspace
            print('amount below max: reset warning');
            exceedMaxBalance = false;
          });
        }
        //if tempAmount becomes empty after backspacing, reset to 0
        if (tempAmount == "" || tempAmount == "0") {
          print("backspace on empty field, reset field to zero");
          tempAmount = "0";
        }
        //default to 0 catchall
      } else {
        tempAmount = "0";
      }
    } else {
      //enforce a 9 digit number or 12 digits with decimal
      if ((amount.contains('.') && amount.length >= 12) ||
          (!amount.contains('.') && amount.length == 9 && input != '.')) {
        print("invalid input: max digits");
        _displayKey.currentState?.shake();
        return;
      }
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
    //check if tempamount exceeds max amount
    double? tempAmountDouble = double.tryParse(tempAmount);
    if (tempAmountDouble != null && tempAmountDouble > maxDollarAmount) {
      print(
          "Attempting to exceed max balance current amount: $amount temp amount: $tempAmount");
      setState(() {
        //show error feedback to the user, disable the continue button
        exceedMaxBalance = true;
        amount = tempAmount;
        evaluateButton(tempAmount, maxDollarAmount);
      });
      //standard key input
    } else {
      setState(() {
        print("standard input amount: $amount temp amount: $tempAmount");
        amount = tempAmount;
        evaluateButton(tempAmount, maxDollarAmount);
      });
    }
  }

  //evalute if the send button should be activated
  void evaluateButton(String tempAmount, maxDollarAmount) {
    double? amountDouble = double.tryParse(amount);
    double? tempAmountDouble = double.tryParse(tempAmount);
    //button only activates if you are not exceed max dollar amount of your wallet, and you enter an amount greater than $0.01
    if (amountDouble != null &&
        amountDouble >= 0.01 &&
        tempAmountDouble! <= maxDollarAmount) {
      isButtonEnabled = true;
      //otherwise it deactivates
    } else {
      isButtonEnabled = false;
    }
  }

  //format a number of satoshis into dollars at the last known exchange rate
  String formatDollarsToBTC(String amount, double? price, bool satsFormat) {
    if (!satsFormat) {
      print("sats format false, giving decimal format");
      //with sats format false, here we format into BTC
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
      //with satsFormat true, here we format into Satoshis
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

  Widget build(BuildContext context) {
    return DefaultInterface(
      header: const StackHeader(
        text: "Send bitcoin",
      ),
      content: Content(
        content: Center(
          child: KeyboardAmountDisplay(
            key: _displayKey,
            fiatAmount: amount == '' ? '0' : amount,
            quantity: amount == ''
                ? formatDollarsToBTC('0', widget.price, false)
                : formatDollarsToBTC(amount, widget.price, false),
            onShake: () {},
            exceedMaxBalance: exceedMaxBalance == true ? true : false,
            maxBalance: ((widget.balance / 100000000) * widget.price!)
                .toStringAsFixed(2),
          ),
        ),
      ),
      bumper: KeypadBumper(
        isEnabled: amount != '' && amount != '0'
            ? exceedMaxBalance == true
                ? false
                : true
            : false,
        updateAmount: _updateAmount,
      ),
    );
  }
}
