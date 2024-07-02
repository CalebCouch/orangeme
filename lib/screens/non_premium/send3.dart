import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orange/screens/non_premium/send4.dart';
import 'package:orange/widgets/fee_selector.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/widgets/session_timer.dart';
import '../../classes.dart';
import 'package:orange/screens/non_premium/send2.dart';

class Send3 extends StatefulWidget {
  final int amount;
  final String address;
  final int balance;
  final double price;
  final SessionTimerManager sessionTimer;
  final VoidCallback onDashboardPopBack;
  Transaction? priorityTransaction;
  Transaction? standardTransaction;
  Send3(
      {super.key,
      required this.amount,
      required this.address,
      required this.balance,
      required this.price,
      required this.onDashboardPopBack,
      required this.sessionTimer, required Transaction standard_tx});
      
  @override
  Send3State createState() => Send3State();
}

String transaction = '';
int standardFee = 0;

class Send3State extends State<Send3> {
  bool isPrioritySelected = false;

  void navigate() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Send4(
                tx: transaction,
                balance: widget.balance,
                amount: widget.amount,
                price: widget.price,
                onDashboardPopBack: widget.onDashboardPopBack,
                sessionTimer: widget.sessionTimer)));
  }

  @override
  void initState() {
    print("initializing send3");
    super.initState();
  //  createTransaction();
    //send the user back to the dashboard if the session expires
    widget.sessionTimer.setOnSessionEnd(() {
      if (mounted) {
        widget.onDashboardPopBack();
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    print("disposing send3");
    super.dispose();
  }

  //fired when user selects priority
  //this currently does nothing other than change the visual indicator
  void onOptionSelected(bool isSelected) {
    setState(() {
      isPrioritySelected = isSelected;
      print("priority selected");
    });
  }


  @override
  Widget build(BuildContext context) {
    currentCtx = context;
    print("Time left ${widget.sessionTimer.getTimeLeftFormatted()}");
    return PopScope(
      canPop: true,
      //prevents session timer from continuing to run off screen
      onPopInvoked: (bool didPop) async {
        widget.sessionTimer.dispose();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transaction Speed'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                //dashboard timer callback function
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Send2(
                            amount: widget.amount,
                            balance: widget.balance,
                            price: widget.price,
                            onDashboardPopBack: widget.onDashboardPopBack,
                            sessionTimer: widget.sessionTimer,
                            address: widget.address)));
              }),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FeeSelector(
                  onOptionSelected: onOptionSelected,
                  price: widget.price,
                  standardFee: standardFee),
              const Spacer(),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ButtonOrangeLG(
            label: "Continue",
            onTap: navigate,
          ),
        ),
      ),
    );
  }
}
