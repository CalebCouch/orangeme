import 'package:flutter/material.dart';

import 'package:orange/theme/stylesheet.dart';
import 'package:orange/temp_classes.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';

import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/flows/bitcoin/settings.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/custom/custom_icon.dart';

import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/bitcoin/receive/receive.dart';

// This page serves as the main screen for Bitcoin transactions.
// It displays the user's balance in both USD and BTC, a list of recent transactions,
// and provides buttons for sending and receiving Bitcoin. The screen also shows
// optional reminders for backing up and internet connectivity.

class WalletHome extends StatefulWidget {
  final GlobalState globalState;
  final List<Wallet>? wallets;
  const WalletHome(this.globalState,
      {super.key,
      this.wallets = const [
        Wallet(
          "My Wallet",
          [],
          125.23, // balance in USD
          0.00000142, // balance in BTC
          true, // isSpending
        )
      ]});

  @override
  State<WalletHome> createState() => WalletState();
}

class WalletState extends State<WalletHome> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  Widget build_screen(BuildContext context, DartState state) {
    var textSize = formatValue(state.usdBalance).length <= 4
        ? TextSize.title
        : formatValue(state.usdBalance).length <= 7
            ? TextSize.h1
            : TextSize.h2;
    return Interface(
      widget.globalState,
      resizeToAvoidBottomInset: false,
      header: widget.wallets != null && widget.wallets!.length == 1
          ? homeHeader(
              context,
              widget.globalState,
              "Wallet", // change to this wallet's name
            )
          : stackHeader(
              context,
              "Wallet", // change to this wallet's name
              iconButton(
                context,
                () {
                  navigateTo(
                    context,
                    MultiWalletHome(
                      widget.globalState,
                      wallets: widget.wallets!,
                    ),
                  );
                },
                const CustomIcon(iconSize: IconSize.md, icon: ThemeIcon.left),
              ),
              iconButton(
                context,
                () {
                  navigateTo(
                    context,
                    Settings(
                      widget.globalState,
                      wallet: widget.wallets![0],
                    ),
                  );
                },
                const CustomIcon(iconSize: IconSize.md, icon: ThemeIcon.info),
              ),
            ),
      content: Content(
        content: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: AppPadding.valueDisplay),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    textType: "heading",
                    text: state.usdBalance == 0
                        ? "\$0.00"
                        : "\$${formatValue(state.usdBalance)}",
                    textSize: textSize,
                    color: ThemeColor.heading,
                  ),
                  const Spacing(height: AppPadding.valueDisplaySep),
                  CustomText(
                    textType: "text",
                    text: "${formatBTC(state.btcBalance, 8)} BTC",
                    textSize: TextSize.lg,
                    color: ThemeColor.textSecondary,
                  ),
                ],
              ),
            ),
            const Spacing(height: AppPadding.content),
            _backupReminder(false),
            _noInternet(false),
            /* state.transactions.isNotEmpty
                ?*/
            Expanded(
              child: SingleChildScrollView(
                child: transactionListItem(
                  widget.globalState,
                  context,
                  Transaction(
                    false,
                    'bc1asuthaxk8293579axk83bdauci183xukabe',
                    '123',
                    12.53,
                    0.00000142,
                    63204.12,
                    0.34,
                    '2024-12-24',
                    '12:34 PM',
                    'raw',
                  ),
                  true,
                ),
                /*ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: const ScrollPhysics(),
                        itemCount: state.transactions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return transactionListItem(widget.globalState,
                              context, state.transactions[index], false);
                        },
                      ),*/
              ),
            )
            // : Container(),
          ],
        ),
      ),
      bumper: doubleButtonBumper(
        context,
        "Receive",
        "Send",
        () async {
          var address =
              (await widget.globalState.invoke("get_new_address", "")).data;
          navigateTo(context, Receive(widget.globalState, address));
        },
        () {
          navigateTo(context, Send(widget.globalState));
        },
        false,
      ),
      navigationIndex: 0,
    );
  }
}

_backupReminder(bool display) {
  if (display) {
    return const CustomBanner(
      message:
          'orange.me recommends that you back\n your phone up to the cloud.',
    );
  }
  return Container();
}

_noInternet(bool display) {
  if (display) {
    return const CustomBanner(
      message:
          'You are not connected to the internet.\norange.me requires an internet connection.',
      isError: true,
    );
  }
  return Container();
}
