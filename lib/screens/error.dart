import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';

class ErrorPage extends StatefulWidget {
  final String message;

  const ErrorPage({super.key, required this.message});

  @override
  ErrorPageState createState() => ErrorPageState();
}

class ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Stack_Scroll(
      Header_Stack(context, 'Uh-oh!'),
      [
        const CustomText('heading h4 heading', 'Looks like we\'ve hit a snag'),
        Image.asset('assets/images/error.png'),
        const CustomText('text lg heading', 'Please try again or check your connection.'),
        CustomButton('Contact Support', 'secondary md enabled hug none', () {}),
        const CustomText('text md text_secondary', 'Error Message:'),
        Container(
          decoration: BoxDecoration(
            color: ThemeColor.bgSecondary,
            border: Border.all(color: ThemeColor.border),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.all(12),
          child: CustomText('text lg heading', widget.message),
        ),
      ],
    );
  }
}
