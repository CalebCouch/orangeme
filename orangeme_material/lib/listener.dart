import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleKeyboardListener extends StatefulWidget {
  final void Function(String) onPressed;
  final Widget child;

  const SimpleKeyboardListener({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<SimpleKeyboardListener> createState() => _SimpleKeyboardListenerState();
}

class _SimpleKeyboardListenerState extends State<SimpleKeyboardListener> {
  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    if (event is KeyDownEvent) {
      if (isNumeric(key)) {
        widget.onPressed(key);
      }
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        widget.onPressed('backspace');
      }
      if (event.logicalKey == LogicalKeyboardKey.period) {
        widget.onPressed('.');
      }
    }

    return false;
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
