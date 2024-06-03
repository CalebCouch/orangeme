import 'package:flutter/material.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'package:connectivity/connectivity.dart';

class ReceiveSend extends StatefulWidget {
  final Widget Function() receiveRoute;
  final Widget Function() sendRoute;
  final VoidCallback onPause;

  const ReceiveSend({
    super.key,
    required this.receiveRoute,
    required this.sendRoute,
    required this.onPause,
  });

  @override
  ReceiveSendState createState() => ReceiveSendState();
}

class ReceiveSendState extends State<ReceiveSend> {
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        isConnected = (result != ConnectivityResult.none);
      });
    });
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      isConnected = (connectivityResult != ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 393,
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ButtonOrangeLG(
                label: "Receive",
                onTap: () {
                  widget.onPause();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => widget.receiveRoute()),
                  );
                },
                isEnabled: isConnected,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ButtonOrangeLG(
                label: "Send",
                onTap: () {
                  widget.onPause();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => widget.sendRoute()),
                  );
                },
                isEnabled: isConnected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
