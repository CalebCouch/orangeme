import 'package:flutter/material.dart';
import 'package:orange/classes.dart';
import 'package:orange/screens/non_premium/send4.dart';
import 'package:orange/widgets/session_timer.dart';

class Send3 extends StatefulWidget {
  final int amount;
  final int balance;
  final String address;
  final double price;
  final VoidCallback onDashboardPopBack;
  final SessionTimerManager sessionTimer;
  final Transaction priority_tx;
  final Transaction standard_tx;

  const Send3({
    Key? key,
    required this.amount,
    required this.balance,
    required this.address,
    required this.price,
    required this.onDashboardPopBack,
    required this.sessionTimer,
    required this.priority_tx,
    required this.standard_tx,
  }) : super(key: key);

  @override
  Send3State createState() => Send3State();
}

class Send3State extends State<Send3> {
  bool isPrioritySelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Speed'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Priority'),
            leading: Radio<bool>(
              value: true,
              groupValue: isPrioritySelected,
              onChanged: (bool? value) {
                setState(() {
                  isPrioritySelected = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Standard'),
            leading: Radio<bool>(
              value: false,
              groupValue: isPrioritySelected,
              onChanged: (bool? value) {
                setState(() {
                  isPrioritySelected = value!;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Send4(
                    tx: isPrioritySelected
                        ? widget.priority_tx.toJson().toString()
                        : widget.standard_tx.toJson().toString(),
                    balance: widget.balance,
                    amount: widget.amount,
                    price: widget.price,
                    onDashboardPopBack: widget.onDashboardPopBack,
                    sessionTimer: widget.sessionTimer,
                  ),
                ),
              );
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }
}
