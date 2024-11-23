import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';

class Loading extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Container(),
            content: [],
            bumper: Container(),
            isLoading: true,
        );
    }
}
