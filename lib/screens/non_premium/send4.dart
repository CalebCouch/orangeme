import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/components/button.dart';
import 'package:orange/components/session_timer.dart';
import 'send2.dart';
import 'send3.dart';
import 'send1.dart';
import 'send5.dart';

class Send4 extends StatefulWidget {
  final String tx;
  final int balance;
  final int amount;
  final double price;
  final SessionTimerManager sessionTimer;
  final VoidCallback onDashboardPopBack;

  const Send4(
      {super.key,
      required this.tx,
      required this.balance,
      required this.amount,
      required this.price,
      required this.onDashboardPopBack,
      required this.sessionTimer});

  @override
  Send4State createState() => Send4State();
}

class Send4State extends State<Send4> {
  String transactionFee = '0';
  String sendAmount = '0';
  String totalAmount = '0';

  @override
  void initState() {
    print("initializing send4");
    super.initState();
    updateValues();
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
    print("disposing send4");
    super.dispose();
  }

  //broadcast the transaction confirmed by the user
  void broadcastTransaction(String transaction) async {
    print("broadcasting transaction");
    if (!mounted) return;
    var descriptorsRes = await STORAGE.read(key: "descriptors");
    if (!mounted) return;
    var descriptors = handleNull(descriptorsRes, context);
    print("Descriptors: ${descriptors.toString()}");
    String path = await getDBPath();
    print('Path: $path');
    final transactionDecoded = Transaction.fromJson(jsonDecode(widget.tx));
    print("transaction: ${transactionDecoded.toString()}");
    if (!mounted) return;
    var res = await invoke(method: "broadcast_transaction", args: [
      path.toString(),
      descriptors.toString(),
      transactionDecoded.raw.toString()
    ]);
    if (!mounted) return;
    var resHandled = handleError(res, context);
    print("broadcast response: $resHandled");
    await navigateNext(resHandled);
  }

  //dispose of the session timer and broadcast
  void confirmSend() {
    broadcastTransaction(widget.tx);
  }

  //navigate to the success screen
  Future<void> navigateNext(String transaction) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Send5(
                amount: widget.amount,
                price: widget.price,
                onDashboardPopBack: widget.onDashboardPopBack,
              )),
    );
  }

  //update the values displayed onscreen based on the current price
  void updateValues() {
    print("updating values");
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
    print("transaction net: ${transaction.net}");
    print("transaction fee: ${transaction.fee}");
    print("price: ${widget.price}");
    setState(() {
      transactionFee = (transaction.fee! / 100000000 * widget.price) == 0.0
          ? '<0.01'
          : (transaction.fee! / 100000000 * widget.price).toStringAsFixed(2);
      print("transaction fee: $transactionFee");
      sendAmount =
          (widget.amount / 100000000 * widget.price).toStringAsFixed(2);
      print("send amount: $sendAmount");
      totalAmount =
          ((widget.amount + transaction.fee!) / 100000000 * widget.price)
              .toStringAsFixed(2);
      print("total amount: $totalAmount");
    });
  }

  //navigate to the address input screen, user activates by clicking the "edit address" button
  void editAddress() {
    print("edit address selected");
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
    final amount = (transaction.net.abs() - transaction.fee!).toInt();
    print("Sending to Address screen with Amount: $amount");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Send2(
                amount: amount,
                balance: widget.balance,
                price: widget.price,
                onDashboardPopBack: widget.onDashboardPopBack,
                sessionTimer: widget.sessionTimer,
                address: transaction.receiver!)));
  }

  //navigate to the amount input screen, user activates by clicking the "edit amount" button
  void editAmount() {
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
    print("edit amount selected");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Send1(
                  price: widget.price,
                  balance: widget.balance,
                  onDashboardPopBack: widget.onDashboardPopBack,
                  sessionTimer: widget.sessionTimer,
                  address: transaction.receiver!,
                  amount: sendAmount,
                )));
  }

  //navigate to the fee selector screen, user activates by clicking the "edit speed" button
  void editSpeed() {
    print("edit speed selected");
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
    print("sending to edit screen with Amount: ${widget.amount}");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Send3(
                amount: widget.amount,
                balance: widget.balance,
                address: transaction.receiver!,
                price: widget.price,
                onDashboardPopBack: widget.onDashboardPopBack,
                sessionTimer: widget.sessionTimer)));
  }

  @override
  Widget build(BuildContext context) {
    print("Time left ${widget.sessionTimer.getTimeLeftFormatted()}");
    print("Price: ${widget.price}");
    print("Send4 Transaction: ${widget.tx}");
    final decodeJson = jsonDecode(widget.tx);
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
    print("DecodeJSON*************: $decodeJson");
    print("Transaction:************ $transaction");

    return PopScope(
      canPop: true,
      //prevents session timer from continuing to run off screen
      onPopInvoked: (bool didPop) async {
        widget.sessionTimer.dispose();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Confirm Send',
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Send3(
                            amount: widget.amount,
                            balance: widget.balance,
                            address: transaction.receiver!,
                            price: widget.price,
                            onDashboardPopBack: widget.onDashboardPopBack,
                            sessionTimer: widget.sessionTimer)));
              }),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.offBlack,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '1',
                      style: AppTextStyles.heading6,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Confirm Address',
                    style: AppTextStyles.heading5,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 42),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${transaction.receiver}",
                      style: AppTextStyles.textSM,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Bitcoin sent to the wrong address can never be recovered.",
                      style: AppTextStyles.textSM
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    Button(
                        label: "Address",
                        variant: 'secondary',
                        size: 'MD',
                        icon: AppIcons.edit,
                        onTap: editAddress),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '2',
                      style: AppTextStyles.heading6,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Confirm Amount',
                    style: AppTextStyles.heading5,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 42),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Send Amount',
                          style: AppTextStyles.textSM,
                        ),
                        Text(
                          '\$$sendAmount',
                          style: AppTextStyles.textSM,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Fee Amount',
                          style: AppTextStyles.textSM,
                        ),
                        Text(
                          '\$$transactionFee',
                          style: AppTextStyles.textSM,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Total Amount',
                          style: AppTextStyles.textSM,
                        ),
                        Text(
                          '\$$totalAmount',
                          style: AppTextStyles.textSM,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Button(
                            label: "Amount",
                            variant: 'secondary',
                            size: "MD",
                            icon: AppIcons.edit,
                            onTap: editAmount),
                        const SizedBox(width: 10),
                        Button(
                            label: "Speed",
                            variant: 'secondary',
                            size: 'MD',
                            icon: AppIcons.edit,
                            onTap: editSpeed),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ButtonOrangeLG(
            label: "Confirm & Send",
            onTap: confirmSend,
            isEnabled: true,
          ),
        ),
      ),
    );
  }
}
