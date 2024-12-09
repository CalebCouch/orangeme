import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/flows/multi_device/create_wallet/success.dart';

class NewSpendingGuide extends StatefulWidget {
    NewSpendingGuide({super.key});

    @override
    NewSpendingGuideState createState() => NewSpendingGuideState();
}

class NewSpendingGuideState extends State<NewSpendingGuide> {
    int walletCount = 1; //import variable

    @override
    Widget build(BuildContext context) {
        //Only move on if the phone has successfully created a wallet
        void success(){ navigateTo(context, Success('_import wallet name_')); }

        return Stack_Default(
            header: Header_Stack(context, "New spending wallet"),
            content: [
                ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: walletCount == 1 ? Image.asset('assets/mockups/SpendingWalletGuide.png') : Image.asset('assets/mockups/SpendingWalletGuide.png'), // switch to multiwallet
                ),
                CustomTextSpan('Open the orange app on your phone.\n Press the + icon in the top right corner to create a new spending wallet.'),
            ],
            bumper: Container(),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}
