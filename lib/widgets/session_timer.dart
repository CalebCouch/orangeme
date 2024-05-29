import 'dart:async';
import 'package:flutter/material.dart';

class SessionTimerManager extends ChangeNotifier {
  Timer? sessionTimer;
  Duration _timeLeft = const Duration(minutes: 1);
  Function? onSessionEnd;

  SessionTimerManager({this.onSessionEnd, Duration? initialTime}) {
    if (initialTime != null) {
      _timeLeft = initialTime;
    }
  }

  void setOnSessionEnd(Function onEnd) {
    onSessionEnd = onEnd;
    print("on session end callback fired");
  }

  void startTimer() {
    print("start session timer...");
    sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        _timeLeft -= const Duration(seconds: 1);
      } else {
        timer.cancel();
        onSessionEnd?.call();
      }
    });
  }

  Duration getTimeLeft() => _timeLeft;

  String getTimeLeftFormatted() {
    return "${_timeLeft.inMinutes}:${(_timeLeft.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    print("disposing session timer...");
    sessionTimer?.cancel();
    super.dispose();
  }
}
