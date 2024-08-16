import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes/test_classes.dart';
import 'package:orange/classes.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/tip_buttons.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/flows/bitcoin/transaction_details.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/bitcoin/receive/receive.dart';
import 'dart:io' show Platform;

import 'package:orange/util.dart';

class MultiHome extends StatefulWidget {
  final GlobalState globalState;
  final List<Wallet> wallets;
  const MultiHome(this.globalState, this.wallets, {super.key});

  @override
  State<MultiHome> createState() => MultiHomeState();
}

class MultiHomeState extends State<MultiHome> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  Widget walletListItem(BuildContext context, Wallet wallet) {
    return ImageListItem(
      onTap: () {},
      image: Container(
        alignment: Alignment.centerLeft,
        child: profilePhoto(context, null, 'wallet', ProfileSize.lg),
      ),
      topLeft: CustomText(
        text: wallet.name,
        textSize: TextSize.h5,
        textType: 'heading',
      ),
      bottomLeft: CustomText(
        text: wallet.isSpending ? 'Spending' : 'Savings',
        textSize: TextSize.sm,
        color: ThemeColor.textSecondary,
      ),
      topRight: CustomText(
        text: "\$${formatValue(wallet.balance)}",
        textSize: TextSize.h5,
        textType: 'heading',
      ),
      bottomRight: CustomText(
        text: "${wallet.btc} BTC",
        textSize: TextSize.sm,
        color: ThemeColor.textSecondary,
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
      header: onDesktop
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
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  physics: const ScrollPhysics(),
                  itemCount: widget.wallets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return walletListItem(context, widget.wallets[index]);
                  },
                ),
              ),
            )
          ],
        ),
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
