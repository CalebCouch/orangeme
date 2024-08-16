import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orange/classes/test_classes.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/tip_buttons.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/custom/custom_icon.dart';

import 'package:orange/flows/bitcoin/transaction_details.dart';
import 'package:orange/flows/bitcoin/new_wallet/wallet_info.dart';
import 'package:orange/flows/bitcoin/multi_home.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/bitcoin/receive/receive.dart';
import 'dart:io' show Platform;

import 'package:orange/util.dart';

class BitcoinHome extends StatefulWidget {
  final GlobalState globalState;
  final List<Wallet>? wallets;
  const BitcoinHome(
    this.globalState, {
    super.key,
    this.wallets,
  });

  @override
  State<BitcoinHome> createState() => BitcoinHomeState();
}

class BitcoinHomeState extends State<BitcoinHome> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  Widget transactionListItem(BuildContext context, Transaction transaction) {
    return DefaultListItem(
      onTap: () {
        navigateTo(
            context, TransactionDetailsWidget(widget.globalState, transaction));
      },
      topLeft: CustomText(
        alignment: TextAlign.left,
        textType: "text",
        textSize: TextSize.md,
        text: transaction.isReceive ? "Received bitcoin" : "Sent bitcoin",
      ),
      bottomLeft: CustomText(
        alignment: TextAlign.left,
        textSize: TextSize.sm,
        color: ThemeColor.textSecondary,
        text: formatDate(transaction.date, transaction.time),
      ),
      topRight: CustomText(
        alignment: TextAlign.right,
        textSize: TextSize.md,
        text: "\$${formatValue((transaction.usd).abs())}",
      ),
      bottomRight: const CustomText(
        alignment: TextAlign.right,
        textSize: TextSize.sm,
        color: ThemeColor.textSecondary,
        text: "Details",
        underline: true,
      ),
    );
  }

  Widget build_screen(BuildContext context, DartState state) {
    bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    var textSize = formatValue(state.usdBalance).length <= 4
        ? TextSize.title
        : formatValue(state.usdBalance).length <= 7
            ? TextSize.h1
            : TextSize.h2;
    return Interface(
      widget.globalState,
      resizeToAvoidBottomInset: false,
      header: widget.wallets != null && widget.wallets!.length > 1
          ? stackHeader(
              context,
              'Wallet',
              iconButton(
                context,
                () {
                  navigateTo(
                    context,
                    MultiHome(
                      widget.globalState,
                      [
                        Wallet(
                          'Wallet',
                          state.transactions,
                          state.usdBalance,
                          state.btcBalance,
                          true,
                        ),
                      ],
                    ),
                  );
                },
                const CustomIcon(iconSize: IconSize.md, icon: ThemeIcon.left),
                false,
                true,
              ),
              walletInfoButton(
                context,
                WalletInfo(
                  widget.globalState,
                  Wallet(
                    'Wallet',
                    state.transactions,
                    state.usdBalance,
                    state.btcBalance,
                    true,
                  ),
                ),
              ),
            )
          : onDesktop
              ? homeHeader(
                  context,
                  widget.globalState,
                  "Wallet",
                  state.personal.pfp,
                )
              : homeHeader(
                  context,
                  widget.globalState,
                  'Wallet',
                  state.personal.pfp,
                  newWalletButton(context, widget.globalState),
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
                    text: "${formatValue(state.btcBalance, 8)} BTC",
                    textSize: TextSize.lg,
                    color: ThemeColor.textSecondary,
                  ),
                ],
              ),
            ),
            const Spacing(height: AppPadding.content),
            _backupReminder(false),
            _noInternet(false),
            ButtonTip(
              text: 'Connect to a Computer',
              onTap: () {},
            ),
            state.transactions.isNotEmpty
                ? Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: const ScrollPhysics(),
                        itemCount: state.transactions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return transactionListItem(
                              context, state.transactions[index]);
                        },
                      ),
                    ),
                  )
                : Container(),
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
