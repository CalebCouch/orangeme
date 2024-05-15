import 'package:flutter/material.dart';
import 'package:orange/widgets/payment_options.dart';

class ThresholdPopup extends StatefulWidget {
  const ThresholdPopup({super.key});

  @override
  ThresholdPopupState createState() => ThresholdPopupState();
}

class ThresholdPopupState extends State<ThresholdPopup> {
//   void premiumOnboard() {
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => const Payment()));
//   }

//   void optOut() {
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => const WhyNot()));
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Wow you are really STACKING THOSE SATS™!',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 30),
            Text(
              'You are at risk of losing funds, we strongly reccomend you upgrade to premium in order to remain secure.',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 20),
            PaymentOptionsWidget(onSignUp: (selectedOption) {
              //handle sign up
              print("Signed up for $selectedOption");
              // premiumOnboard();
            }, onOptOut: () {
              //handle opt out
              print("user opted out");
              // optOut();
            })
          ],
        ),
      ),
    );
  }
}
