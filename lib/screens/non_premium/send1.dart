import 'package:flutter/material.dart';
import 'package:orange/widgets/numberpad.dart';
import 'package:orange/widgets/keyboard_value_display.dart';
import 'package:orange/screens/non_premium/send2.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'package:orange/widgets/session_timer.dart';
import 'package:orange/components/headings/stack.dart';

class Send1 extends StatefulWidget {
  final int balance;
  final double? price;
  final SessionTimerManager? sessionTimer;
  final VoidCallback onDashboardPopBack;
  final String? address;
  final String? amount;

  const Send1({
    super.key,
    required this.balance,
    required this.price,
    required this.onDashboardPopBack,
    this.sessionTimer,
    this.address,
    this.amount,
  });

  @override
  Send1State createState() => Send1State();
}

class Send1State extends State<Send1> {
  String amount = "0";
  final GlobalKey<KeyboardValueDisplayState> _displayKey =
      GlobalKey<KeyboardValueDisplayState>();
  bool isButtonEnabled = false;
  bool exceedMaxBalance = false;
  late SessionTimerManager sessionTimer;

  @override
  void initState() {
    print("initializing send1");
    super.initState();
    //this condition applies if the user is returning from further in the flow
    if (widget.amount != null) {
      setState(() {
        amount = widget.amount!;
      });
      double maxDollarAmount = (widget.balance / 100000000) * widget.price!;
      evaluateButton(widget.amount!, maxDollarAmount);
    }
    print("WIDGET TIMER MANAGER: ${widget.sessionTimer}");
    //initialize the send flow session timer
    if (widget.sessionTimer != null) {
      print("TIMER MANAGER IS NOT NULL, PRESERVE STATE");
      // Use the existing timer manager if passed from another screen
      sessionTimer = widget.sessionTimer!;
      //send the user back to the dashboard if the session expires
      sessionTimer.setOnSessionEnd(() {
        if (mounted) {
          widget.onDashboardPopBack();
          Navigator.pop(context);
        }
      });
    } else {
      print("TIMER MANAGER IS NULL, START TIMER");
      // Create a new timer manager if none was passed which sends the user back to the dashboard if session expires
      sessionTimer = SessionTimerManager(onSessionEnd: () {
        if (mounted) {
          widget.onDashboardPopBack();
          Navigator.pop(context);
        }
      });
      //start the new timer
      sessionTimer.startTimer();
    }
  }

  @override
  void dispose() {
    print("disposing send1");
    super.dispose();
  }

  //algorithim used to control the logic of the virtual keyboard
  void _updateAmount(String input) {
    print('keyboard input received: $input');
    print("current amount: $amount");
    double maxDollarAmount = (widget.balance / 100000000) * widget.price!;
    print("max amount to spend: $maxDollarAmount");
    String tempAmount = amount; // Currently displayed amount
    if (input == "backspace") {
      // When input is backspace, handle deletion
      if (tempAmount.length > 1) {
        //accept the backspace
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
    // Ensure tempAmount is a valid dollar amount with at most two decimal places
    if (!RegExp(r"^\d*\.?\d{0,2}$").hasMatch(tempAmount) &&
        input != 'backspace') {
      print("invalid input: engage haptics");
      _displayKey.currentState?.shake();
      return; // Return if not a valid format
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

  //used to navigate to the next page in the send flow
  void onContinue() {
    int qty = int.parse(formatDollarsToBTC(amount, widget.price, true));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Send2(
          amount: qty,
          balance: widget.balance,
          price: widget.price!,
          onDashboardPopBack: widget.onDashboardPopBack,
          sessionTimer: sessionTimer,
          address: widget.address
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Time left ${sessionTimer.getTimeLeftFormatted()}");
    print("Price: ${widget.price}");
    print("Exceed max balance: $exceedMaxBalance");
    return PopScope(
      canPop: true,
      //prevents session timer from continuing to run off screen
      onPopInvoked: (bool didPop) async {
        sessionTimer.dispose();
        if (widget.sessionTimer != null) {
          widget.sessionTimer!.dispose();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize (
          preferredSize: const Size.fromHeight(64.0),
          child: HeadingStack(label: "Send bitcoin", onDashboardPopBack: widget.onDashboardPopBack),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              KeyboardValueDisplay(
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
              const Spacer(),
              NumberPad(
                onNumberPressed: _updateAmount,
              ),
              const SizedBox(height: 10),
              ButtonOrangeLG(
                label: "Send",
                onTap: () => onContinue(),
                isEnabled: isButtonEnabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
