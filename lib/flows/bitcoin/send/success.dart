import 'package:flutter/material.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/classes.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';

//import 'package:orange/global.dart' as global;

class Success extends GenericWidget {
  Success({super.key});

  late String usd;

  @override
  SuccessState createState() => SuccessState();
}

class SuccessState extends GenericState<Success> {
  @override
  PageName getPageName() {
    return PageName.success;
  }

  @override
  int refreshInterval() {
    return 0;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
      widget.usd = json['usd'];
    });
  }

  onDone() {
    resetNavTo(context, BitcoinHome());
  }

  @override
  Widget build_with_state(BuildContext context) {
    return Stack_Default(
      Header_Stack(context, "Confirm send", Container(), exitButton(context, BitcoinHome())),
      [
        Result('You sent ${widget.usd}'),
      ],
      Bumper(context, [CustomButton('Done', 'secondary lg expand none', onDone, 'enabled')]),
      Alignment.center,
      false,
    );
  }
}

Widget Result(String resultMessage, [String icon = 'bitcoin']) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CustomIcon('$icon xxl'),
      const Spacing(16),
      CustomText('heading h3', resultMessage),
    ],
  );
}
