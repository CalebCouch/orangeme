import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/flows/bitcoin/send/confirmation.dart';
import 'package:orange/flows/bitcoin/transactions/cancel.dart';
import 'package:orange/components/interface.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/data_item.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class ConfirmTransaction extends StatefulWidget {
  final GlobalState globalState;
  //final String address;
  //final double btc;
  //final int fee_index;
  //final Transaction tx;
  const ConfirmTransaction(this.globalState, {super.key});

  @override
  ConfirmState createState() => ConfirmState();
}

class ConfirmState extends State<ConfirmTransaction> {
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
    return Interface(
      widget.globalState,
      header: homeDesktopHeader(
        context,
        'Confirm send',
      ),
      content: Content(
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              'bc1axk832rUXareht23TaxkrSlacoixairc82du92x47k82' != null
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
                            text:
                                'bc1axk832rUXareht23TaxkrSlacoixairc82du92x47k82',
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
                    )
                  : Container(),
              const Spacing(height: AppPadding.bumper),
              DataItem(
                title: "Confirm Amount",
                listNum: 2,
                content: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppPadding.bumper),
                  child: confirmationTabular(
                    context,
                    Transaction(
                        false,
                        'bc1axk832rUXareht23TaxkrSlacoixairc82du92x47k82',
                        '123445',
                        20.12,
                        0.00001234,
                        16402.12,
                        0.41,
                        '2024-5-12',
                        '12:23 PM',
                        'idk'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bumper: doubleButtonBumper(
        context,
        "Cancel",
        'Confirm',
        () {
          navigateTo(context, Cancel(widget.globalState));
        },
        () {
          navigateTo(context, Confirmation(widget.globalState, 20.12));
        },
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
