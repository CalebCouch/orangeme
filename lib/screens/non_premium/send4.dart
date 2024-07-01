import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/components/buttons/secondary_md.dart';
import 'package:orange/widgets/session_timer.dart';
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

  const Send4({
    Key? key,
    required this.tx,
    required this.balance,
    required this.amount,
    required this.price,
    required this.onDashboardPopBack,
    required this.sessionTimer,
  }) : super(key: key);

  @override
  Send4State createState() => Send4State();
}

class Send4State extends State<Send4> {
  String transactionFee = '0';
  String sendAmount = '0';
  String totalAmount = '0';

  @override
  void initState() {
    print("Initializing Send4");
    super.initState();
    updateValues();
    widget.sessionTimer.setOnSessionEnd(() {
      if (mounted) {
        widget.onDashboardPopBack();
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    print("Disposing Send4");
    super.dispose();
  }

  void broadcastTransaction(String transaction) async {
    print("Broadcasting transaction");
    if (!mounted) return;
    var descriptorsRes = await STORAGE.read(key: "descriptors");
    if (!mounted) return;

    final transactionDecoded = Transaction.fromJson(jsonDecode(widget.tx));
    print("######################################");
    print("Transaction: ${transactionDecoded.toString()}");
    if (!mounted) return;
    var res = (await invoke("broadcast_transaction", "")).data;
    if (!mounted) return;
    var resHandled = res;
    print("Broadcast response: $resHandled");
    await navigateNext(resHandled);
  }

  void confirmSend() {
    broadcastTransaction(widget.tx);
  }

  Future<void> navigateNext(String transaction) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Send5(
          amount: widget.amount,
          price: widget.price,
          onDashboardPopBack: widget.onDashboardPopBack,
        ),
      ),
    );
  }

  void updateValues() {
    print("Updating values");
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
    setState(() {
      transactionFee = (transaction.fee! / 100000000 * widget.price) == 0.0
          ? '<0.01'
          : (transaction.fee! / 100000000 * widget.price).toStringAsFixed(2);
      sendAmount =
          (widget.amount / 100000000 * widget.price).toStringAsFixed(2);
      totalAmount =
          ((widget.amount + transaction.fee!) / 100000000 * widget.price)
              .toStringAsFixed(2);
    });
  }

  void editAddress() {
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
    final amount = (transaction.net.abs() - transaction.fee!).toInt();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Send2(
          amount: amount,
          balance: widget.balance,
          price: widget.price,
          onDashboardPopBack: widget.onDashboardPopBack,
          sessionTimer: widget.sessionTimer,
          address: transaction.receiver!,
        ),
      ),
    );
  }

  void editAmount() {
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
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
        ),
      ),
    );
  }

  void editSpeed() {
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Send3(
          amount: widget.amount,
          balance: widget.balance,
          address: transaction.receiver!,
          price: widget.price,
          onDashboardPopBack: widget.onDashboardPopBack,
          sessionTimer: widget.sessionTimer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Time left ${widget.sessionTimer.getTimeLeftFormatted()}");
    print("Price: ${widget.price}");
    print("Send4 Transaction: ${widget.tx}");

    final decodeJson = jsonDecode(widget.tx);
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
    print("DecodeJSON: $decodeJson");
    print("Transaction: $transaction");

    return WillPopScope(
      onWillPop: () async {
        widget.sessionTimer.dispose();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Confirm Send'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                      style: AppTextStyles.textSM.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ButtonSecondaryMD(
                      label: "Address",
                      icon: "edit",
                      onTap: editAddress,
                    ),
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
                        ButtonSecondaryMD(
                          label: "Amount",
                          icon: "edit",
                          onTap: editAmount,
                        ),
                        const SizedBox(width: 10),
                        ButtonSecondaryMD(
                          label: "Speed",
                          icon: "edit",
                          onTap: editSpeed,
                        ),
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
