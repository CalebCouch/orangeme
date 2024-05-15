import 'package:flutter/material.dart';
import '../../widgets/payment_options.dart';
import '../premium onboard/payment.dart';

class SavingsDashboard extends StatefulWidget {
  const SavingsDashboard({super.key});

  @override
  SavingsDashboardState createState() => SavingsDashboardState();
}

//hardcoded for now, set to false to see premium onboarding flow, set to true to see savings dashboard
bool premium = false;

void premiumChallenge() {
  //evluate here
  bool premium = false;
  if (premium == true) {
    //show wallet
  } else {
    //show premium onboard
  }
}

//handles a manual refresh initiated by the user with a pull down request
Future<void> handleRefresh() async {
  //sync & fetch the latest balance and transaction data
  print('Pulldown Refresh Initiatied...');
  print('Getting Balance...');
  print('Getting Transactions...');
  print('Getting exchange rate');
}

class SavingsDashboardState extends State<SavingsDashboard> {
  void premiumOnboard() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Payment()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: !premium
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'The Savings Wallet is only avaiable to Premium Users.',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  PaymentOptionsWidget(
                    onSignUp: (selectedOption) {
                      //handle sign up
                      print("Signed up for $selectedOption");
                      premiumOnboard();
                    },
                    showOptOutButton: false,
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Savings Dashboard will go here',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
            ),
    );
  }
}
