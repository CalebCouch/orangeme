import 'package:flutter/material.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';

class Success extends StatefulWidget {
  String amount_sent; //"$10.00"
  Success(this.amount_sent, {super.key});

  @override
  SuccessState createState() => SuccessState();
}

class SuccessState extends State<Success> {

    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Confirm send", Container(), exitButton(context, BitcoinHome())),
            content: [Result(text: 'You sent ${widget.amount_sent}')],
            bumper: Bumper(context, content: [
                CustomButton(
                    txt: 'Done', 
                    variant: 'secondary', 
                    onTap: () {resetNavTo(context, BitcoinHome());},
                ),
            ]),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}

Widget Result ({required String text, String icon = 'bitcoin'}) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            CustomIcon(icon: icon, size: 'xxl'),
            const Spacing(16),
            CustomText(variant:'heading', font_size: 'h3', txt: text),
        ],
    );
}
