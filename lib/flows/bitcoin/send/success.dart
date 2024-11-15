import 'package:flutter/material.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';

//import 'package:orange/global.dart' as global;

class Success extends StatefulWidget {
  String usd;
  Success(this.usd, {super.key});

  @override
  SuccessState createState() => SuccessState();
}

class SuccessState extends State<Success> {
    onDone() {
        resetNavTo(context, BitcoinHome());
    }

    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Confirm send", Container(), exitButton(context, BitcoinHome())),
            content: [Result('You sent ${widget.usd}')],
            bumper: Bumper(context, content: [
                CustomButton(
                    txt: 'Done', 
                    variant: 'secondary',
                    size: 'lg',
                    onTap: onDone,
                ),
            ]),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}

Widget Result(String resultMessage, [String icon = 'bitcoin']) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            CustomIcon(icon: icon, size: 'xxl'),
            const Spacing(16),
            CustomText(variant:'heading', font_size: 'h3', txt: resultMessage),
        ],
    );
}
