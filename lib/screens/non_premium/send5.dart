import 'package:flutter/material.dart';
import 'package:orange/screens/non_premium/dashboard.dart';
import 'package:orange/components/buttons/secondary_lg.dart';

class Send5 extends StatefulWidget {
  final String transaction;

  const Send5({
    super.key,
    required this.transaction,
  });

  @override
  Send5State createState() => Send5State();
}

class Send5State extends State<Send5> {
  void navigateHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Dashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('placeholder'),
            Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ButtonSecondaryLG(
          label: "Done",
          onTap: navigateHome,
        ),
      ),
    );
  }
}
