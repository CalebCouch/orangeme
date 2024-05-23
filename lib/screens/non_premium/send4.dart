import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'dart:convert';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

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
    var descriptors =
        HandleNull(await STORAGE.read(key: "descriptors"), context);
    String path = await GetDBPath();
    print(transaction);
    var res = HandleError(
        await invoke(
            method: "broadcast_transaction",
            args: [path, descriptors, transaction]),
        context);
    await navigateHome();
  }

  void discard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Dashboard()),
    );
  }

  Future<void> navigateHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Dashboard()),
    );
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
          'Confirm Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Address: ${transaction.receiver}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Amount: ${transaction.net}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Fee: ${transaction.fee}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {broadcastTransaction(transaction.raw ?? '')},
              child: const Text(
                'Send',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => {discard()},
              child: const Text(
                'Discard',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
