import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orange/temp_classes.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/banner.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/custom/custom_icon.dart';

import 'package:orange/flows/bitcoin/wallet.dart';
import 'package:orange/flows/pairing/pair.dart';
import 'package:orange/flows/new_wallet/type.dart';
import 'package:orange/util.dart';

// NEEDED VARIABLES
// List of wallets
// Total balance

class MultiWalletHome extends StatefulWidget {
  final GlobalState globalState;
  final List<Wallet> wallets;
  const MultiWalletHome(this.globalState, {super.key, required this.wallets});

  @override
  State<MultiWalletHome> createState() => MultiWalletHomeState();
}

class MultiWalletHomeState extends State<MultiWalletHome> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  _getWalletsTotalUSD(List<Wallet> wallets) {
    double totalBalance = 0;
    for (var wallet in wallets) {
      totalBalance = totalBalance + wallet.balance;
    }
    return totalBalance;
  }

  _getWalletsTotalBTC(List<Wallet> wallets) {
    double totalBalance = 0;
    for (var wallet in wallets) {
      totalBalance = totalBalance + wallet.btc;
    }
    return totalBalance;
  }

  Widget build_screen(BuildContext context, DartState state) {
    var totalUSD = _getWalletsTotalUSD(widget.wallets);
    var totalBTC = _getWalletsTotalBTC(widget.wallets);
    var textSize = formatValue(totalUSD).length <= 4
        ? TextSize.title
        : formatValue(totalUSD).length <= 7
            ? TextSize.h1
            : TextSize.h2;
    return Interface(
      widget.globalState,
      resizeToAvoidBottomInset: false,
      header: homeHeader(
        context,
        widget.globalState,
        "Wallet",
        true,
        iconButton(
          context,
          () {
            navigateTo(context, WalletType(widget.globalState));
          },
          const CustomIcon(
            icon: ThemeIcon.add,
            iconSize: IconSize.md,
          ),
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
                        : "\$${formatValue(totalUSD)}",
                    textSize: textSize,
                    color: ThemeColor.heading,
                  ),
                  const Spacing(height: AppPadding.valueDisplaySep),
                  CustomText(
                    textType: "text",
                    text: "${formatBTC(totalBTC, 8)} BTC",
                    textSize: TextSize.lg,
                    color: ThemeColor.textSecondary,
                  ),
                ],
              ),
            ),
            const Spacing(height: AppPadding.content),
            _backupReminder(false),
            _noInternet(false),
            ButtonTip('Connect to a Computer', null, () {
              navigateTo(
                context,
                Pair(widget.globalState),
              );
            }, padding: true),
            const Spacing(height: AppPadding.content),
            widget.wallets.isNotEmpty
                ? Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: const ScrollPhysics(),
                        itemCount: widget.wallets.length,
                        itemBuilder: (BuildContext context, int index) {
                          return walletListItem(
                            context,
                            widget.wallets[index],
                            () {
                              navigateTo(
                                context,
                                WalletHome(widget.globalState, wallets: const [
                                  Wallet(
                                    "My Wallet",
                                    [],
                                    125.23, // balance in USD
                                    0.00000142, // balance in BTC
                                    true, // isSpending
                                  ),
                                  Wallet(
                                    "My Wallet 2",
                                    [],
                                    194.12, // balance in USD
                                    0.00001826, // balance in BTC
                                    true, // isSpending
                                  )
                                ]),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  )
                : Container(),
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
