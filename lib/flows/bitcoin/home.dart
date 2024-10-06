import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/classes.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/flows/bitcoin/receive/receive.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/bitcoin/transaction_details.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/util.dart';
import 'package:orangeme_material/orangeme_material.dart';

class BitcoinHome extends StatefulWidget {
  final GlobalState globalState;
  const BitcoinHome(this.globalState, {super.key});

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

  onReceive() async {
    var address = (await widget.globalState.invoke("get_new_address", "")).data;
    navigateTo(context, Receive(widget.globalState, address));
  }

  onSend() {
    navigateTo(context, Send(widget.globalState));
  }

  Widget build_screen(BuildContext context, DartState state) {
    return Root_Home(
      widget.globalState,
      Header_Home(ProfileButton, "Wallet"),
      [
        BalanceDisplay(state),
        BackupReminder(false),
        NoInternet(false),
        TransactionList(state, TransactionItem),
      ],
      Bumper([
        CustomButton('Receive', 'primary lg enabled expand none', onReceive()),
        CustomButton('Send', 'primary lg enabled expand none', onSend()),
      ]),
      0,
    );
  }
}

//The following widgets can ONLY be used in this file

Widget BalanceDisplay(DartState state) {
  dynamic_size(x) {
    if (x <= 4) return 'title';
    if (x <= 7) return 'h1';
    return 'h2';
  }

  String usd = state.usdBalance == 0 ? "\$0.00" : "\$${formatValue(state.usdBalance)}";

  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(vertical: AppPadding.valueDisplay),
    child: CustomColumn([
      CustomText('heading ${dynamic_size(formatValue(state.usdBalance).length)}', '$usd USD'),
      CustomText('text lg text_secondary', '${formatBTC(state.btcBalance, 8)} BTC')
    ], AppPadding.valueDisplaySep),
  );
}

BackupReminder(bool display) {
  return display
      ? const CustomBanner(
          'orange.me recommends that you back\n your phone up to the cloud.',
        )
      : Container();
}

NoInternet(bool display) {
  return display
      ? const CustomBanner(
          'You are not connected to the internet.\norange.me requires an internet connection.',
          isError: true,
        )
      : Container();
}

Widget TransactionList(state, TransactionItem) {
  return Expanded(
    child: SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        reverse: true,
        physics: const ScrollPhysics(),
        itemCount: state.transactions.length,
        itemBuilder: (BuildContext context, int index) {
          return TransactionItem(context, state.transactions[index]);
        },
      ),
    ),
  );
}

Widget TransactionItem(GlobalState globalState, BuildContext context, Transaction transaction) {
  return ListItem(
    onTap: () {
      HapticFeedback.mediumImpact();
      navigateTo(context, ViewTransactionDetails(globalState, transaction));
    },
    title: transaction.isReceive ? "Received bitcoin" : "Sent bitcoin",
    sub: formatDate(transaction.date, transaction.time),
    titleR: "\$${formatValue((transaction.usd).abs())}",
    subR: "Details",
  );
}
