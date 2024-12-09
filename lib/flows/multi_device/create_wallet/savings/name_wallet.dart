import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/flows/multi_device/create_wallet/savings/continue_desktop.dart';
import 'package:orange/components/radio.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/components/qr_code/qr_code.dart';
import 'package:tuple/tuple.dart';

class NameWallet extends StatefulWidget {
    NameWallet({super.key});

    @override
    NameWalletState createState() => NameWalletState();
}

class NameWalletState extends State<NameWallet> {
    late TextEditingController _walletName;
    bool isEnabled = true;

    @override
    void initState() {
        super.initState();
        _walletName = TextEditingController(text: 'My Savings');
    }

    @override
    void dispose() {
        _walletName.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Name wallet"),
            content: [NameWallet()],
            bumper: Bumper(context, content: [CustomButton(txt: 'Continue', onTap: () {navigateTo(context, ContinueDesktop());}, enabled: isEnabled)]),
        );
    }

    Widget NameWallet() {
        return CustomTextInput(
            title: 'Wallet name',
            hint: 'My Savings',
            onChanged: (String str) => setState(() {isEnabled = _walletName.text.isNotEmpty;}),
            controller: _walletName,
        );
    }
}
