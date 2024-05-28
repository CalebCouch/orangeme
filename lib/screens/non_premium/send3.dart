import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orange/screens/non_premium/send4.dart';
import 'package:orange/widgets/fee_selector.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';

import '../../classes.dart';

class Send3 extends StatefulWidget {
  final int amount;
  final String address;
  final int balance;
  final double price;

  Send3(
      {super.key,
      required this.amount,
      required this.address,
      required this.balance,
      required this.price});

  @override
  Send3State createState() => Send3State();
}

String transaction = '';
int standardFee = 0;

class Send3State extends State<Send3> {
  bool isPrioritySelected = false; //state to keep track of selection

  void navigate() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Send4(
                tx: transaction,
                balance: widget.balance,
                amount: widget.amount,
                price: widget.price)));
  }

  @override
  void initState() {
    super.initState();
    createTransaction();
  }

  @override
  void dispose() {
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

  //create the transaction for display on the next page of the flow
  void createTransaction() async {
    var desc = await STORAGE.read(key: "descriptors");
    String db = await getDBPath();
    if (desc != null) {
      print("database: $db");
      print("descriptor: $desc");
      print("Address: ${widget.address}");
      print("Amount: ${widget.amount.toString()}");
      var jsonRes = await invoke(method: "create_transaction", args: [
        db.toString(),
        desc.toString(),
        widget.address.toString(),
        widget.amount.toString()
      ]);

      if (!mounted) return;
      var json = handleError(jsonRes, context);
      print("create tx response: $json");
      calculateStandardFee(json);
      setState(() {
        transaction = json;
      });
    }
    print("building tx and sending user to confirmation screen");
  }

  void calculateStandardFee(String transaction) {
    final transactionDecoded = Transaction.fromJson(jsonDecode(transaction));
    setState(() {
      standardFee = transactionDecoded.fee!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Speed'),
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
    );
  }
}
