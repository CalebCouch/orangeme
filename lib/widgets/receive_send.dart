import 'package:flutter/material.dart';
import 'package:orange/components/buttons/orange_lg.dart';

class ReceiveSend extends StatelessWidget {
  final Widget Function() receiveRoute;
  final Widget Function() sendRoute;
  final VoidCallback onPause;
  final VoidCallback onResume;

  const ReceiveSend({
    super.key,
    required this.receiveRoute,
    required this.sendRoute,
    required this.onPause,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 393,
      height: 80,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ButtonOrangeLG(
                label: "Receive",
                onTap: () {
                  onPause();
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => receiveRoute()))
                      .then((_) => onResume());
                }),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ButtonOrangeLG(
                label: "Send",
                onTap: () {
                  onPause();
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => sendRoute()))
                      .then((_) => onResume());
                }),
          ),
        ],
      ),
    );
  }
}
