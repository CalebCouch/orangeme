import 'package:flutter/material.dart';
import 'package:orange/screens/non_premium/send4.dart';
import 'package:orange/widgets/fee_selector.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';

class Send3 extends StatefulWidget {
  final double amount;
  final String address;

  const Send3({super.key, required this.amount, required this.address});

  @override
  Send3State createState() => Send3State();
}

class Send3State extends State<Send3> {
  bool isPrioritySelected = false; //state to keep track of selection

  void navigate(String json) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Send4(tx: json)));
  }

  //fired when user selects priority
  //this currently does nothing other than change the visual indicator
  void onOptionSelected(bool isSelected) {
    setState(() {
      isPrioritySelected = isSelected;
      print("priority selected");
    });
  }

  //create the transaction for display on the next page of the flow
  void createTransaction() async {
    var desc = await STORAGE.read(key: "descriptors");
    String db = await getDBPath();
    double convertedAmount = widget.amount * 100000000;
    if (desc != null) {
      print("database: $db");
      print("descriptor: $desc");
      print("Address: ${widget.address}");
      print("Amount: $convertedAmount");
      var jsonRes = await invoke(method: "create_transaction", args: [
        db.toString(),
        desc.toString(),
        widget.address.toString(),
        convertedAmount.round().toString()
      ]);
      if (!mounted) return;
      var json = handleError(jsonRes, context);
      navigate(json);
    }
    print("building tx and sending user to confirmation screen");
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Transaction Speed'),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           FeeSelector(onOptionSelected: onOptionSelected),
  //           const SizedBox(height: 20),
  //           ButtonOrangeLG(
  //             label: "Continue",
  //             onTap: createTransaction,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Speed'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FeeSelector(onOptionSelected: onOptionSelected),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ButtonOrangeLG(
          label: "Continue",
          onTap: createTransaction,
        ),
      ),
    );
  }
}
