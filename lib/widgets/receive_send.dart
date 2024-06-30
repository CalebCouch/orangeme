import 'package:flutter/material.dart';
import 'package:orange/components/buttons/orange_lg.dart';

class ReceiveSend extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ButtonOrangeLG(
              label: "Receive",
              onTap: () {
                onPause();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => receiveRoute()),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ButtonOrangeLG(
              label: "Send",
              onTap: () {
                onPause();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => sendRoute()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
