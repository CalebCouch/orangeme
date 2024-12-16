import 'package:flow_bitcoin/flow_bitcoin.dart';
import 'package:flow_messages/flow_messages.dart';
import 'package:flow_profiles/flow_profiles.dart';

import 'package:material/material.dart';

class BitcoinHome extends GenericWidget {
    BitcoinHome({super.key});

    String? profile_picture;
    String balance_usd = "";
    String balance_btc = "";
    List<ShorthandTransaction> transactions = [];

    @override
    BitcoinHomeState createState() => BitcoinHomeState();
}

class BitcoinHomeState extends GenericState<BitcoinHome> {
    @override
    PageName getPageName() {
        return PageName.bitcoinHome();
    }

    @override
    unpack_state(Map<String, dynamic> json) {
        widget.profile_picture = json["profile_picture"] as String?;
        widget.balance_usd = json["balance_usd"] as String;
        widget.balance_btc = json["balance_btc"] as String;

        widget.transactions = List<ShorthandTransaction>.from(json['transactions'].map(
            (json) => ShorthandTransaction(
                isWithdraw: json['is_withdraw'] as bool,
                datetime: json['datetime'] as String,
                amount: json['amount'] as String,
                txid: json['txid'] as String,
            )
        ));
    }

    onReceive() {navigateTo(Receive());}
    onSend() {navigateTo(Send());}
    toProfile() {navigateTo(MyProfile());}

    @override
    Widget build_with_state(BuildContext context) {
        bool noTransactions = widget.transactions.isEmpty;
        return Root_Home(
            header: Header_Home(context, "Wallet", widget.profile_picture, toProfile),
            content: [
                BalanceDisplay(),
                InternetBanner(super.isConnected()),
                TransactionList(),
            ],
            bumper: Bumper(context, content: [
                CustomButton(txt: 'Receive', onTap: onReceive, enabled: super.isConnected()),
                CustomButton(txt: 'Send', onTap: onSend, enabled: super.isConnected()),
            ]),
            tabNav: TabNav(0, [TabInfo(BitcoinHome(), 'wallet'), TabInfo(MessagesHome(), 'message')]),
            alignment: noTransactions && super.isConnected() ? Alignment.center : Alignment.topCenter,
            scroll: !noTransactions,
        );
    }

    //The following widgets can ONLY be used in this file

    Widget BalanceDisplay() {
        int txtL = widget.balance_usd.length - 1;
        return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 64),
            child: FittedBox(
                child: CustomColumn([
                    CustomText(
                        variant: 'heading',
                        font_size: txtL <= 4 ? 'title' : txtL <= 7 ? 'h1' : 'h2',
                        txt: widget.balance_usd,
                    ),
                    CustomText(
                        variant: 'text',
                        font_size: 'lg',
                        text_color: 'text_secondary',
                        txt: widget.balance_btc,
                    ) 
                ], AppPadding.valueDisplaySep),
            )
        );
    }

    Widget BackupReminder(bool display) {
        return display ? SizedBox() : CustomBanner(
            'orange recommends that you back\n your phone up to the cloud.',
        );
    }

    Widget InternetBanner(bool internet) {
        return internet ? SizedBox() : CustomBanner(
          'You are not connected to the internet.\norange requires an internet connection.',
        );
    }

    Widget TransactionList() {
        return ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: widget.transactions.length,
            itemBuilder: (BuildContext context, int index) {
                return TransactionItem(widget.transactions[index]);
            },
        );
    }

    Widget TransactionItem(ShorthandTransaction transaction) {
        return ListItem(
            onTap: () {
                HapticFeedback.mediumImpact();
                navigateTo(ViewTransaction(txid: transaction.txid.toString()));
            },
            title: transaction.isWithdraw ? "Sent bitcoin" : "Received bitcoin",
            sub: transaction.datetime,
            titleR: transaction.amount,
            subR: "Details",
            caret: false,
        );
    }
}