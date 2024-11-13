import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:intl/intl.dart";

String cutString(String text, {int leftSizeLength = 9, int rightSizeLengthOffset = 3}) {
  var dotsString = '...'; // Always use three dots
  var rightSizeLength = text.length - rightSizeLengthOffset;
  var leftPart = text.substring(0, leftSizeLength);
  var rightPart = text.substring(rightSizeLength);
  return '$leftPart$dotsString$rightPart';
}

DisplayData updateDisplayAmount(String input, double usdBalance, double price, String amount) {
  double min = 0.30;
  double max = usdBalance - min;

  String updatedAmount;
  bool validation;

  switch (input) {
    case 'reset':
      updatedAmount = '0';
      validation = true;
      break;
    case 'backspace':
      if (amount == '0') {
        updatedAmount = amount;
        validation = false;
      } else if (amount.length == 1) {
        updatedAmount = '0';
        validation = true;
      } else {
        updatedAmount = amount.substring(0, amount.length - 1);
        validation = true;
      }
      break;
    case '.':
      if (!amount.contains('.') && amount.length <= 7) {
        updatedAmount = '$amount.';
        validation = true;
      } else {
        updatedAmount = amount;
        validation = false;
      }
      break;
    default:
      if (amount == '0') {
        updatedAmount = input;
        validation = true;
      } else if (amount.contains('.')) {
        List<String> split = amount.split('.');
        if (amount.length < 11 && split[1].length < 2) {
          updatedAmount = '$amount$input';
          validation = true;
        } else {
          updatedAmount = amount;
          validation = false;
        }
      } else if (amount.length < 10) {
        updatedAmount = '$amount$input';
        validation = true;
      } else {
        updatedAmount = amount;
        validation = false;
      }
      break;
  }

  // Handle decimals
  String decimals = '';
  if (updatedAmount.contains('.')) {
    List<String> split = updatedAmount.split('.');
    int decimalsLen = split.length > 1 ? split[1].length : 0;
    if (decimalsLen < 2) {
      decimals = '0' * (2 - decimalsLen);
    }
  }

  double updatedAmountF64 = double.tryParse(updatedAmount) ?? 0.0;

  String? err;
  if (updatedAmountF64 != 0.0) {
    if (max <= 0.0) {
      err = 'You have no bitcoin';
    } else if (updatedAmountF64 < min) {
      err = '\$${min.toStringAsFixed(2)} minimum';
    } else if (updatedAmountF64 > max) {
      err = '\$${max.toStringAsFixed(2)} maximum';
    }
  }

  // Return the result as a map of set values
  return DisplayData(updatedAmount, err ?? '', updatedAmountF64 / price, decimals, validation);
}

class DisplayData {
  String amount;
  String err;
  double btc;
  String decimals;
  bool valid;

  DisplayData(this.amount, this.err, this.btc, this.decimals, this.valid);
}
