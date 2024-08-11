import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/flows/wallet/transaction_details.dart';

import 'package:orange/flows/wallet/send/send.dart';
import 'package:orange/flows/wallet/receive/receive.dart';

import 'package:orange/util.dart';
import 'package:intl/intl.dart';

class WalletHome extends StatefulWidget {
  final GlobalState globalState;
  const WalletHome(this.globalState, {super.key});

  @override
  State<WalletHome> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  _getDate(String? date, String? time) {
    if (date == null) return 'Pending';
    if (time != null && date == DateTime.now().toString()) {
      return time;
    }
    if (date == DateTime.now().subtract(const Duration(days: 1)).toString()) {
      return 'Yesterday';
    }
    return DateFormat.MMMMd()
        .format(DateFormat('yyyy-MM-dd').parse(date))
        .toString();
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
        text: _getDate(transaction.date, transaction.time),
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
    var textSize = formatValue(state.usdBalance).length <= 4
        ? TextSize.title
        : formatValue(state.usdBalance).length <= 7
            ? TextSize.h1
            : TextSize.h2;
    return Interface(
      resizeToAvoidBottomInset: false,
      header: primaryHeader(
        context,
        "Wallet",
      ),
      content: Content(
        scrollable: true,
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
                    text: "\$${formatValue(state.usdBalance)}",
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
            ListView.builder(
              shrinkWrap: true,
              reverse: true,
              physics: const ScrollPhysics(),
              itemCount: state.transactions.length,
              itemBuilder: (BuildContext context, int index) {
                return transactionListItem(context, state.transactions[index]);
              },
            ),
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
      globalState: widget.globalState,
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
