import 'package:flutter/material.dart';
import 'package:orange/widgets/payment_options.dart';
import '../premium onboard/payment.dart';
import '../opt out/why_not.dart';

class BackUp extends StatefulWidget {
  const BackUp({super.key});

  @override
  BackUpState createState() => BackUpState();
}

class BackUpState extends State<BackUp> {
  void premiumOnboard() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Payment()));
  }

  void optOut() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const WhyNot()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back Up'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'We strongly encourage you to upgrade to a premium membership in order to backup your wallet.',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            PaymentOptionsWidget(onSignUp: (selectedOption) {
              //handle sign up
              print("Signed up for $selectedOption");
              premiumOnboard();
            }, onOptOut: () {
              //handle opt out
              print("user opted out");
              optOut();
            })
          ],
        ),
      ),
    );
  }
}
