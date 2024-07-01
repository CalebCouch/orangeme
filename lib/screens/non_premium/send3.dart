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
  final Transaction? transaction;

  final int standardFee = 0;
  final int priorityFee = 0;

  Send3({
    super.key,
    required this.amount,
    required this.address,
    required this.balance,
    required this.price,
    required this.onDashboardPopBack,
    required this.sessionTimer,
  });

  @override
  Send3State createState() => Send3State();
}

class Send3State extends State<Send3> {
  bool isPrioritySelected = false;

  void navigate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Send4(
          tx: widget.transaction,
          balance: widget.balance,
          amount: widget.amount,
          price: widget.price,
          onDashboardPopBack: widget.onDashboardPopBack,
          sessionTimer: widget.sessionTimer,
        ),
      ),
    );
  }

  @override
  void initState() {
    print("##################### initState #####################");
    super.initState();
    (await invoke("estimate_fee", ""))
    createTransaction();
    widget.sessionTimer.setOnSessionEnd(() {
      if (mounted) {
        widget.onDashboardPopBack();
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    print("##################### dispose #####################");
    super.dispose();
  }

  void onOptionSelected(bool isSelected) {
    setState(() {
      isPrioritySelected = isSelected;
      print("priority selected");
    });
  }

  Future<void> createTransaction() async {
    try {
      var input = CreateTransactionInput(
        widget.address.toString(),
        widget.amount.toString(),
        widget.standardFee.toString(),
      );
      var jsonRes =
          (await invoke("create_transaction", jsonEncode(input))).data;
      var local_transaction = Transaction.fromJson(jsonDecode(jsonRes));
      calculateStandardFee(local_transaction.fee.toString());
      widget.transaction = local_transaction;
    } catch (e) {
      ERROR = e.toString();
    }
  }

  void calculateStandardFee(String fee) {
    setState(() {
      standardFee = int.parse(fee);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("##################### build #####################");
    print("Time left ${widget.sessionTimer.getTimeLeftFormatted()}");
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) async {
        widget.sessionTimer.dispose();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transaction Speed'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Send2(
                    amount: widget.amount,
                    balance: widget.balance,
                    price: widget.price,
                    onDashboardPopBack: widget.onDashboardPopBack,
                    sessionTimer: widget.sessionTimer,
                    address: widget.address,
                  ),
                ),
              );
            },
          ),
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
                standardFee: standardFee,
              ),
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
