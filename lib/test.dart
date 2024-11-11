import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/global.dart' as global;

import 'package:orange/src/rust/api/pub_structs.dart';

class Test extends GenericWidget {
  Test({super.key});

  int val = 0;

  @override
  TestState createState() => TestState();
}

class TestState extends GenericState<Test> {
  @override
  PageName getPageName() {
    return PageName.test;
  }

  @override
  int refreshInterval() {
    return 1;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
      widget.val = json["count"] as int;
    });
  }

  @override
  Widget build_with_state(BuildContext context) {
    return Column(children: <Widget>[
      Text("count: ${widget.val}"),
      //TextButton(
      //  onPressed: test,
      //  child: Text('TextButton')
      //)
    ]);
  }
}
