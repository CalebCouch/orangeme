import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/components/buttons/secondary_lg.dart';
import 'package:orange/styles/constants.dart';

class Send5 extends StatefulWidget {
  final int amount;
  final double price;
  final VoidCallback onDashboardPopBack;

  const Send5(
      {super.key,
      required this.amount,
      required this.price,
      required this.onDashboardPopBack});

  @override
  Send5State createState() => Send5State();
}

class Send5State extends State<Send5> {
  //send the user back to the dashboard
  void navigateHome() {
    widget.onDashboardPopBack();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    String sentTotal =
        (widget.amount / 100000000 * widget.price).toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Confirmed'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              //dashboard timer callback function
              widget.onDashboardPopBack();
              Navigator.pop(context);
            }),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              SvgPicture.asset('assets/icons/bitcoinsuccess.svg'),
              Text('You sent \$$sentTotal', style: AppTextStyles.heading3),
              const Spacer(),
            ],
          ),
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
