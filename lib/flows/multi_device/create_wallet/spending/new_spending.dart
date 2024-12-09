import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/flows/multi_device/create_wallet/success.dart';
import 'package:orange/components/radio.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/components/qr_code/qr_code.dart';
import 'package:tuple/tuple.dart';

class NewSpending extends StatefulWidget {
    NewSpending({super.key});

    @override
    NewSpendingState createState() => NewSpendingState();
}

class NewSpendingState extends State<NewSpending> {
    late TextEditingController _walletName;
    int walletCount = 1; // Pull from state
    bool isEnabled = true;

    @override
    void initState() {
        super.initState();
        _walletName = TextEditingController(text: 'Wallet ${walletCount + 1}');
    }

    @override
    void dispose() {
        _walletName.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "New spending wallet"),
            content: [NameWallet()],
            bumper: Bumper(context, content: [CustomButton(txt: 'Continue', onTap: () {navigateTo(context, Success(_walletName.text));}, enabled: isEnabled)]),
        );
    }

    Widget NameWallet() {
        return CustomTextInput(
            title: 'Wallet name',
            hint: 'Wallet ${walletCount + 1}',
            onChanged: (String str) => setState(() {isEnabled = _walletName.text.isNotEmpty;}),
            controller: _walletName,
        );
    }
}
