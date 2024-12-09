import 'package:flutter/material.dart';
import 'package:orangeme_material/color.dart';

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

Future<void> resetNavTo(BuildContext context, int back) async {
    int index = 0;
    while (index < back) {
        if (Navigator.canPop(context)) {
            Navigator.pop(context);
            index++;
        } else {
            print('No more routes to pop!');
            break;
        }
    }
}



Future navigateToReturn(BuildContext context, Widget widget) async {
    final leData = await Navigator.of(context).push(
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => widget,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero, 
        ),
    );

    return leData;
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

Widget loadingCircle() {
    return const Center(
        child: CircularProgressIndicator(
            strokeCap: StrokeCap.round,
            backgroundColor: ThemeColor.bgSecondary,
        ),
    );
}
