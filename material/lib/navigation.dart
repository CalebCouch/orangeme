import 'package:flutter/material.dart';
import 'package:material/material.dart';

Future<void> navigateTo(BuildContext context, Widget widget) async {
    Navigator.push(
        context,
            PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => widget,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
        ),
    );
}

Future navigateToReturn(BuildContext context, Widget widget) async {
    final returnedData = await Navigator.of(context).push(
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => widget,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero, 
        ),
    );

    return returnedData;
}

Future<void> navPop(BuildContext context) async {
    Navigator.pop(context);
}

Future<void> switchPageTo(
    BuildContext context,
    Widget widget,
) async {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => widget,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
        ),
    );
}

Future<void> resetNavTo(BuildContext context, Widget widget) async {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => widget,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
        ),
        (route) => false
    );
}

Widget loadingCircle() {
    return const Center(
        child: CircularProgressIndicator(
            strokeCap: StrokeCap.round,
            backgroundColor: ThemeColor.bgSecondary,
        ),
    );
}
