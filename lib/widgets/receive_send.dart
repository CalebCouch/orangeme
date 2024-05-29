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
      width: 393,
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
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
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
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
          ),
        ],
      ),
    );
  }
}
