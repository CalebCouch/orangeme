import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/tab_navigator.dart';
import 'package:orange/flows/multi_device/create_wallet/add_wallet.dart';
import 'package:orange/flows/bitcoin/receive/receive.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/bitcoin/view_transaction.dart';
import 'package:orange/flows/profile/my_profile.dart';
import 'package:orange/flows/messages/home.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/generic.dart';

class MultiWallet extends GenericWidget {
    MultiWallet({super.key});

    String address = "";
    
    @override
    MultiWalletState createState() => MultiWalletState();
}

class MultiWalletState extends GenericState<MultiWallet> {

    @override
    PageName getPageName() {
        return PageName.multiWallet();
    }

    @override
    int refreshInterval() {
        return 0;
    }

    @override
    unpack_state(Map<String, dynamic> json) {
        widget.walletCount = json["wallet_count"] as int;
        widget.balance_usd = json["balance_usd"] as String;
        widget.balance_btc = json["balance_btc"] as String;
        widget.profile_picture = json["profile_picture"] as String?;

        widget.walletsList = List<DartWallet>.from(json['wallets'].map(
            (json) => DartWallet(
                name: json['name'] as String,
                type: json['type'] as String,
                usd: json['usd'] as String,
                btc: json['btc'] as String,
            )
        ));
    }

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        toProfile() {navigateTo(context, MyProfile());}

        return Root_Home(
            header: Header_Home(context, "Wallets", profile_picture, toProfile, NewWallet()),
            content: [
                BalanceDisplay(),
                WalletsList(),
            ],
            bumper: SizedBox(),
            tabNav: TabNav(0, [TabInfo(MultiWallet(), 'wallet'), TabInfo(MessagesHome(), 'message')]),
        );
    }

    Widget BalanceDisplay() {
        int txtL = balance_usd.length - 1;
        return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 64),
            child: FittedBox(
                child: CustomColumn([
                    CustomText(
                        variant: 'heading',
                        font_size: txtL <= 4 ? 'title' : txtL <= 7 ? 'h1' : 'h2',
                        txt: balance_usd,
                    ),
                    CustomText(
                        variant: 'text',
                        font_size: 'lg',
                        text_color: 'text_secondary',
                        txt: balance_btc,
                    ) 
                ], AppPadding.valueDisplaySep),
            )
        );
    }

    Widget WalletsList() {
        return ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: walletsList.length,
            itemBuilder: (BuildContext context, int index) {
                return WalletItem(walletsList[index]);
            },
        );
    }

    Widget WalletItem(DartWallet wallet) {
        return ListItem(
            onTap: () { HapticFeedback.mediumImpact(); },
            visual: ProfilePhoto(display_icon: 'wallet', variant: 'brand'),
            title: wallet.name,
            sub: wallet.type,
            titleR: wallet.balanceUsd,
            subR: wallet.balanceBtc,
            subR_underline: false,
            caret: false,
        );
    }

    Widget NewWallet(){ return CreateWalletButton(context, AddWallet()); }
}


// DART WALLET BRUHHH

class DartWallet {
    String name;
    String type; 
    String balanceUsd;
    String balanceBtc;

    DartWallet({
        required this.name,
        required this.type,
        required this.balanceUsd,
        required this.balanceBtc,
    });
}