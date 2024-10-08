import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orange/util.dart';
import 'package:orangeme_material/orangeme_material.dart';

class ErrorPage extends StatefulWidget {
  final String message;

  const ErrorPage({super.key, required this.message});

  @override
  ErrorPageState createState() => ErrorPageState();
}

class ErrorPageState extends State<ErrorPage> {
  bool showError = false;
  @override
  Widget build(BuildContext context) {
    onTap() {
      if (showError) {
        setState(() {
          showError = false;
        });
      } else {
        setState(() {
          showError = true;
        });
      }
    }

    back() {
      navPop(context);
    }

    return Stack_Default(
      Container(),
      [
        const Spacing(24),
        Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeColor.bgSecondary,
          ),
          child: SvgPicture.asset('assets/images/error.svg'),
        ),
        const CustomText('heading h3 heading', 'Oops! Something  went wrong.'),
        Container(height: 1, width: 400, color: ThemeColor.bgSecondary),
        CustomButton(showError ? 'Hide Error' : 'Show Error', 'secondary md enabled hug none', onTap),
        showError ? error(widget.message) : Container(),
        const Spacing(12),
      ],
      Bumper(context, [CustomButton('Try Again', 'secondary lg enabled expand none', back)]),
    );
  }
}

Widget error(message) {
  return Container(
    decoration: BoxDecoration(
      color: ThemeColor.bgSecondary,
      border: Border.all(color: ThemeColor.border),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    padding: const EdgeInsets.all(12),
    child: CustomText('text lg heading', message),
  );
}
