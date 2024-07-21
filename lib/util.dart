import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

navigateTo(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => widget,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}

Future<void> navPop(BuildContext context) async {
  FocusScope.of(context).unfocus();
  await new Future.delayed(new Duration(milliseconds: 250));
  Navigator.pop(context);
}

switchPageTo(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => widget,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}

resetNavTo(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => widget,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false);
}

String transactionCut(String text, int length) {
  const numberOfDots = 3;
  var dotsString = List<String>.filled(numberOfDots, '.').join();
  var leftSizeLengh = 9;
  var rightSizeLength = text.length - 3;
  var leftPart = text.substring(0, leftSizeLengh);
  var rightPart = text.substring(rightSizeLength);
  return '$leftPart$dotsString$rightPart';
}

String middleCut(String text, int length) {
  const numberOfDots = 3;
  var dotsString = List<String>.filled(numberOfDots, '.').join();

  var leftSizeLengh = ((length - numberOfDots) / 2).floor();
  var rightSizeLength = text.length - leftSizeLengh;
  var leftPart = text.substring(0, leftSizeLengh);
  var rightPart = text.substring(rightSizeLength);
  return '$leftPart$dotsString$rightPart';
}

bool isValidAddress(String string) {
  return true;
}

Future<String?> getClipBoardData() async {
  ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
  if (data != null) return data.text;
  return 'null';
}

getCurrentBitcoinPrice() {
  return 63492.13;
}
