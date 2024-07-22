import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/flows/wallet_flow/send_flow/confirmation.dart';
import 'package:orange/flows/wallet_flow/send_flow/send_amount.dart';
import 'package:orange/flows/wallet_flow/send_flow/transaction_speed.dart';
import 'package:orange/flows/wallet_flow/send_flow/send.dart';

import 'package:orange/components/default_interface.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/data_item.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class ConfirmSend extends StatefulWidget {
  final GlobalState globalState;
  final Transaction tx;
  const ConfirmSend(this.globalState, this.tx, {super.key});

  @override
  ConfirmState createState() => ConfirmState();
}

class ConfirmState extends State<ConfirmSend> {
  final TextEditingController recipientAddressController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  Widget buildScreen(BuildContext context, DartState state) {
    return DefaultInterface(
      header: stackHeader(
        context,
        'Confirm send',
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.tx.sentAddress != null
                ? DataItem(
                    title: "Confirm Address",
                    listNum: 1,
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacing(height: AppPadding.bumper),
                        CustomText(
                          textSize: TextSize.md,
                          alignment: TextAlign.left,
                          text: widget.tx.sentAddress!,
                        ),
                        const Spacing(height: AppPadding.bumper),
                        const CustomText(
                          textSize: TextSize.sm,
                          color: ThemeColor.textSecondary,
                          alignment: TextAlign.left,
                          text:
                              "Bitcoin sent to the wrong address can never be recovered.",
                        ),
                        const Spacing(height: AppPadding.bumper),
                      ],
                    ),
                    buttonNames: const ["Address"],
                    buttonActions: [
                      () {
                        resetNavTo(
                          context,
                          Send(widget.globalState),
                        );
                      }
                    ],
                  )
                : Container(),
            const Spacing(height: AppPadding.bumper),
            DataItem(
              title: "Confirm Amount",
              listNum: 2,
              content: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: AppPadding.bumper),
                child: confirmationTabular(context, widget.tx),
              ),
              buttonNames: const ["Amount", "Speed"],
              buttonActions: [
                () {
                  resetNavTo(
                    context,
                    SendAmount(widget.globalState, ''),
                  );
                },
                () {
                  resetNavTo(
                    context,
                    TransactionSpeed(
                      widget.globalState,
                      widget.tx.txid,
                      widget.tx.btc,
                    ),
                  );
                }
              ],
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Confirm & Send",
        () {
          navigateTo(
            context,
            Confirmation(
              widget.globalState,
              amount: 45.32,
            ),
          );
        },
      ),
    );
  }
}

_getTransactionData() {
  return Transaction(false, '12FWmGPUCtFeZECFydRARUzfqt7h2GBqEL', '', 5.00,
      0.0000017, 63402.92, 2.15, '1/2/23', '2:23PM', null);
}
