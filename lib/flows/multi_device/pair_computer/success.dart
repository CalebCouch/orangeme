import 'package:flutter/material.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/generic.dart';
import 'package:orange/flows/profile/my_profile.dart';
import 'package:orange/components/result.dart';

class Success extends StatefulWidget {
    Success({super.key});

    @override
    SuccessState createState() => SuccessState();
}

class SuccessState extends State<Success> {

    Widget build(BuildContext context) {
        print()
        return Stack_Default(
            header: Header_Stack(context, "Connection success", Container(), ExitButton(context, MyProfile())),
            content: [Result(message: 'Your computer has been connected to this device', icon: 'checkmark')],
            bumper: Bumper(context, content: [
                CustomButton(
                    txt: 'Done', 
                    variant: 'secondary', 
                    onTap: () {resetNavTo(MyProfile());},
                ),
            ]),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}
