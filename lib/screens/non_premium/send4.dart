import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'dart:convert';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/components/buttons/secondary_md.dart';

class Send4 extends StatefulWidget {
  final String tx;
  const Send4({
    super.key,
    required this.tx,
  });

  @override
  Send4State createState() => Send4State();
}

class Send4State extends State<Send4> {
  @override
  void initState() {
    super.initState();
    updatePrice();
  }

  @override
  void dispose() {
    super.dispose();
  }
  // void _showSuccessAnimation(BuildContext context) {
  //   if (_isSuccessDisplayed) return;
  //   _isSuccessDisplayed = true;

  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Center(
  //         child: Material(
  //           color: Colors.transparent,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               AnimatedContainer(
  //                 duration: const Duration(seconds: 1),
  //                 width: 100,
  //                 height: 100,
  //                 decoration: const BoxDecoration(
  //                   color: Colors.black54,
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: const Icon(
  //                   Icons.check,
  //                   color: Colors.green,
  //                   size: 60,
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               const Text(
  //                 'Success!',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 24,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );

  //   Future.delayed(const Duration(seconds: 1), () {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const Dashboard()),
  //     );
  //   });
  // }

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

  void updatePrice() {
    print("getting latest price");
  }

  void editAddress() {
    print("edit address selected");
  }

  void editAmount() {
    print("edit amount selected");
  }

  void editSpeed() {
    print("edit speed selected");
  }

  @override
  Widget build(BuildContext context) {
    print("Send4 Transaction: ${widget.tx}");
    final decodeJson = jsonDecode(widget.tx);
    final transaction = Transaction.fromJson(jsonDecode(widget.tx));
    print("DecodeJSON*************: $decodeJson");
    print("Transaction:************ $transaction");

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirm Send',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Confirm Address',
              style: AppTextStyles.heading5,
            ),
            const SizedBox(height: 10),
            Text("${transaction.receiver}", style: AppTextStyles.textSM),
            const SizedBox(height: 10),
            Text("Bitcion sent to the wrong address can never be recovered",
                style: AppTextStyles.textSM
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 10),
            ButtonSecondaryMD(
                label: "Address", icon: "edit", onTap: editAddress),
            const SizedBox(height: 20),
            const Text(
              'Confirm Amount',
              style: AppTextStyles.heading5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Send Amount',
                  style: AppTextStyles.textSM,
                ),
                Text('${transaction.net.abs()}', style: AppTextStyles.textSM),
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
                Text('${transaction.fee}', style: AppTextStyles.textSM),
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
                Text('${transaction.net.abs()}', style: AppTextStyles.textSM),
              ],
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 20),
            ButtonOrangeLG(
              label: "Confirm & send",
              onTap: confirmSend,
            )
          ],
        ),
      ),
    );
  }
}
