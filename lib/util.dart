import 'package:flutter/material.dart';

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
