import 'package:flutter/material.dart';
import 'package:orange/components/tabular/transaction_tabular.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interfaces/default_interface.dart';

import 'package:orange/components/list_item/transaction_list_item.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/messages_header.dart';
import 'package:orange/components/amount_display/amount_display.dart';
import 'package:orange/components/bumpers/double_button_bumper.dart';
import 'package:orange/components/tab_navigator/tab_navigator.dart';

import 'package:orange/flows/wallet_flow/send_flow/send.dart';
import 'package:orange/flows/wallet_flow/receive_flow/receive.dart';

import 'package:orange/util.dart';

class MessagesHome extends StatelessWidget {
  const MessagesHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultInterface(
      header: const MessagesHeader(
        profilePhoto: '',
      ),
      content: const Content(
        content: Column(
          children: [],
        ),
      ),
      bumper: DoubleButton(
        firstText: "Receive",
        secondText: "Send",
        firstOnTap: () {
          navigateTo(context, const Receive());
        },
        secondOnTap: () {
          navigateTo(context, const Send());
        },
      ),
      navBar: const TabNav(),
    );
  }
}
