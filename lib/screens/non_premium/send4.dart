import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:orange/classes.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/components/buttons/secondary_md.dart';
import 'package:orange/widgets/session_timer.dart';
import 'send5.dart';
import 'send2.dart';

class Send4 extends StatefulWidget {
  final Transaction tx;
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
  @override
  void initState() {
    super.initState();
    widget.sessionTimer.setOnSessionEnd(() {
      if (mounted) {
        widget.onDashboardPopBack();
        Navigator.pop(context);
      }
    });
  }

  void broadcastTransaction(Transaction tx) async {
    print("###############");
    print(tx);
    if (!mounted) return;
    print("Broadcasting transaction: $tx");
    var res = (await invoke("broadcast_transaction", jsonEncode(tx))).data;
    print("Broadcast result: $res");

    if (!mounted) return;

    var resHandled = res;
    await navigateNext(resHandled);
  }

  void confirmSend() {
    print("Confirm Send called");

    if (widget.tx != null) {
      print("Transaction: ${widget.tx}");
      broadcastTransaction(widget.tx.raw);
    } else {
      print("Transaction is null");
      print(widget.tx);
    }
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

  void navigateToSend2() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Send2(
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
  Widget build(BuildContext context) {
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
                      "Bitcoin sent to the wrong address can never be recovered.",
                      style: AppTextStyles.textSM.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ButtonSecondaryMD(
                      label: "Address",
                      icon: "edit",
                      onTap: navigateToSend2,
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
                      ],
                    ),
                    const SizedBox(height: 10),
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
            onTap: () => confirmSend(),
            isEnabled: true,
          ),
        ),
      ),
    );
  }
}
