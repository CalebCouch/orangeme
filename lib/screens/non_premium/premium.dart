import 'package:flutter/material.dart';
import 'package:orange/util.dart';
import '../opt out/why_not.dart';

class Premium extends StatefulWidget {
  const Premium({super.key});

  @override
  PremiumState createState() => PremiumState();
}

class PremiumState extends State<Premium> {
  void optOut() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const WhyNot()));
  }

  @override
  Widget build(BuildContext context) {
    currentCtx = context;
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'The Savings Wallet is only avaiable to Premium Users.',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 20),
              Text(
                'Premium Coming Soon',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ),
        ));
  }
}
