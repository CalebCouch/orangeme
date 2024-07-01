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
          sessionTimer: widget.sessionTimer,
        ),
      ),
    );
  }

  @override
  void initState() {
    print("##################### initState #####################");
    super.initState();
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
    print("##################### createTransaction #####################");
    print("Address: ${widget.address}");
    print("Amount: ${widget.amount.toString()}");

    var input = CreateTransactionInput(
      widget.address.toString(),
      widget.amount.toString(),
      standardFee.toString(),
    );

    print(jsonEncode(input));

    try {
      var jsonRes = await invoke("create_transaction", jsonEncode(input));
      print("JSON Response: $jsonRes");
      if (jsonRes != null && jsonRes.toString().trim() != '') {
        print("####################################");
        print(jsonRes.toString());
        try {
          var jsonResponse = jsonDecode(jsonRes.toString());
          
          print("Decoded JSON: $jsonResponse");

          if (jsonResponse is Map<String, dynamic>) {
            var transactionData = Transaction.fromJson(jsonResponse);
            calculateStandardFee(transactionData.fee.toString());
            setState(() {
              transaction = jsonRes.toString();
            });
          } else {
            print("Error: Response format is not as expected");
          }
        } catch (e) {
          print("Error decoding JSON: $e");
        }
      } else {
        print("Error: Received empty or null JSON response");
      }
    } catch (e) {
      print("Error invoking API: $e");
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
