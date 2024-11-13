import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  LoadingPageState createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Stack_Default(
      Container(),
      [
        Container(),
      ],
      Container(),
      Alignment.center,
      false,
      true,
    );
  }
}
