import 'package:flutter/material.dart';
import 'package:orange/components/buttons/orange_lg.dart';

class ReceiveSend extends StatelessWidget {
  final Widget Function() receiveRoute;
  final Widget Function() sendRoute;

  const ReceiveSend({
    super.key,
    required this.receiveRoute,
    required this.sendRoute,
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
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => receiveRoute()))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ButtonOrangeLG(
                label: "Send",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => sendRoute()))),
          ),
        ],
      ),
    );
  }
}
