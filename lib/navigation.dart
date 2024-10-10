import 'package:flutter/material.dart';
import 'package:orange/error.dart';

class Navigation {
    GlobalKey<NavigatorState> navkey;

    Navigation(this.navkey);

    factory Navigation.init() {
        return Navigation(GlobalKey<NavigatorState>());
    }

    throwError(String err) {
        Navigator.pushReplacement(
            this.navkey.currentContext!,
            MaterialPageRoute(builder: (context) => ErrorPage(message: err)),
        );
    }

    Future<void> navigateTo(Widget widget) async {
      await Navigator.push(
        this.navkey.currentContext!,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => widget,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }

    navPop() {
      Navigator.pop(this.navkey.currentContext!);
    }

    switchPageTo(Widget widget) {
      var context = this.navkey.currentContext!;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => widget,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }

    resetNavTo(Widget widget) {
      var context = this.navkey.currentContext!;
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => widget,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
          (route) => false);
    }
}



