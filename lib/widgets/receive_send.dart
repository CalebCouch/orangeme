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
      width: MediaQuery.of(context).size.width,
      child: Padding (
        padding: new EdgeInsets.symmetric(horizontal: 24.0),
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
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => receiveRoute(),
                      transitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ButtonOrangeLG(
                label: "Send",
                onTap: () {
                  onPause();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => sendRoute(),
                      transitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
