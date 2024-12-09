import 'package:flutter/material.dart';
import 'package:orange/flows/multi_device/create_wallet/spending/new_spending.dart';
import 'package:orange/flows/multi_device/create_wallet/savings/new_savings.dart';
import 'package:orange/flows/multi_device/create_wallet/spending/spending_guide.dart';
import 'package:orange/flows/multi_device/create_wallet/savings/savings_guide.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/components/radio.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/components/qr_code/qr_code.dart';
import 'package:tuple/tuple.dart';
import 'package:orange/global.dart' as global;

class AddWallet extends StatefulWidget {
    AddWallet({super.key});

    @override
    AddWalletState createState() => AddWalletState();
}

class AddWalletState extends State<AddWallet> {
    int index = 0;

    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Add wallet"),
            content: [TypeSelector()],
            bumper: Bumper(context, content: [CustomButton(
                txt: 'Continue', 
                onTap: () {
                    if(index == 0) {
                        if (global.platform_isDesktop) { 
                            navigateTo(context, NewSpendingGuide());
                        } else {
                            navigateTo(context, NewSpending());
                        }
                    } else {
                        if (global.platform_isDesktop) { 
                            navigateTo(context, NewSavingsGuide());
                        } else {
                            navigateTo(context, NewSavings());
                        }
                    }
                }
            )]),
        );
    }

    Widget TypeSelector(){
        return ListSelector(
            one: Tuple2("Spending Wallet", "Create a bitcoin wallet stored on your phone for easy use"), 
            two: Tuple2("Savings Wallet", "Create a bitcoin wallet that is safe even if your phone gets hacked"),
            currentIndex: index,
            onIndexChanged: (newIndex) {
                setState(() {
                    index = newIndex;
                });
            },
        );
    }
}
