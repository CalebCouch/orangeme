import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';

List<String> updateAmount(GlobalState globalState, String input, String error, amount, shakeController) {
  var buzz = FeedbackType.warning;
  HapticFeedback.heavyImpact();
  var updatedAmount = "0";
  if (input == "backspace") {
    if (amount.length == 1) {
      updatedAmount = "0";
    } else if (amount.isNotEmpty) {
      updatedAmount = amount.substring(0, amount.length - 1);
    } else {
      Vibrate.feedback(buzz);
      shakeController.shake();
      updatedAmount = amount;
    }
  } else if (input == ".") {
    if (!amount.contains(".") && amount.length <= 7) {
      updatedAmount = amount += ".";
    } else {
      Vibrate.feedback(buzz);
      shakeController.shake();
      updatedAmount = amount;
    }
  } else {
    if (amount == "0") {
      updatedAmount = input;
    } else if (amount.contains(".")) {
      if (amount.length < 11 && amount.split(".")[1].length < 2) {
        updatedAmount = amount + input;
      } else {
        Vibrate.feedback(buzz);
        shakeController.shake();
        updatedAmount = amount;
      }
    } else {
      if (amount.length < 10) {
        updatedAmount = amount + input;
      } else {
        Vibrate.feedback(buzz);
        shakeController.shake();
        updatedAmount = amount;
      }
    }
  }

  double min = globalState.state.value.fees[0] + 0.10;
  var max = globalState.state.value.usdBalance - min;
  max = max > 0 ? max : 0;
  var err = "";
  if (double.parse(updatedAmount) != 0) {
    if (double.parse(updatedAmount) <= min) {
      err = "\$${formatValue(min)} minimum.";
    } else if (double.parse(updatedAmount) > max) {
      err = "\$${formatValue(max)} maximum.";
      if (err == "\$0 maximum.") {
        err = "You have no bitcoin.";
      }
    }
  }
  return [amount = updatedAmount, error = err];
}
