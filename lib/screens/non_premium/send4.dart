import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'dart:convert';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/components/buttons/secondary_md.dart';
import 'send2.dart';
import 'send3.dart';
import 'send1.dart';

class Send4 extends StatefulWidget {
  final String tx;
  final int balance;
  const Send4({
    super.key,
    required this.tx,
    required this.balance,
  });

  @override
  Send4State createState() => Send4State();
}

class Send4State extends State<Send4> {
  double price = 0.0;
  String transactionFee = '0';
  String sendAmount = '0';
  String totalAmount = '0';

  @override
  void initState() {
    super.initState();
    updatePrice();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void broadcastTransaction(String transaction) async {
    if (!mounted) return;
    var descriptorsRes = await STORAGE.read(key: "descriptors");
    if (!mounted) return;
    var descriptors = handleNull(descriptorsRes, context);
    String path = await getDBPath();
    print(transaction);
    if (!mounted) return;
    var res = await invoke(
        method: "broadcast_transaction",
        args: [path, descriptors, transaction]);
    if (mounted) {
      handleError(res, context);
      await navigateHome();
    }
  }

  void confirmSend() {
    broadcastTransaction(widget.tx);
  }

  Future<void> navigateHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Dashboard()),
    );
  }

  Future<void> updatePrice() async {
    print('Getting Price...');
    var priceRes = await invoke(method: "get_price", args: []);
    if (!mounted) return;
    setState(() {
      price = double.parse(handleError(priceRes, context));
    });
    print("Price: $price");
    updateValues();
  }

  void updateValues() {
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
    setState(() {
      transactionFee = (transaction.fee! / 100000000 * price) == 0.0
          ? '<0.01'
          : (transaction.fee! / 100000000 * price).toStringAsFixed(2);
      print("transaction fee: $transactionFee");
      sendAmount =
          ((transaction.net.abs() - transaction.fee!) / 100000000 * price)
              .toStringAsFixed(2);
      print("send amount: $sendAmount");
      totalAmount =
          (transaction.net.abs() / 100000000 * price).toStringAsFixed(2);
      print("total amount: $totalAmount");
    });
  }

  void editAddress() {
    print("edit address selected");
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
    final amount = (transaction.net.abs() - transaction.fee!).toInt();
    print("Sending to Address screen with Amount: $amount");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Send2(amount: amount, balance: widget.balance)));
  }

  void editAmount() {
    print("edit amount selected");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Send1(price: price, balance: widget.balance)));
  }

  void editSpeed() {
    print("edit speed selected");
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
    final amount = (transaction.net.abs() - transaction.fee!).toInt();
    print("sending to edit screen with Amount: $amount");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Send3(
                amount: amount,
                balance: widget.balance,
                address: transaction.receiver!)));
  }

  @override
  Widget build(BuildContext context) {
    print("Price: $price");
    print("Send4 Transaction: ${widget.tx}");
    final decodeJson = jsonDecode(widget.tx);
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
    print("DecodeJSON*************: $decodeJson");
    print("Transaction:************ $transaction");

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirm Send',
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
                    style: AppTextStyles.textSM
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  ButtonSecondaryMD(
                      label: "Address", icon: "edit", onTap: editAddress),
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
                          label: "Amount", icon: "edit", onTap: editAmount),
                      const SizedBox(width: 10),
                      ButtonSecondaryMD(
                          label: "Speed", icon: "edit", onTap: editSpeed),
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
    );
  }
}
