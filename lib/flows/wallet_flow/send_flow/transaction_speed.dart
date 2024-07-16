import 'package:flutter/material.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/radio_selectors.dart';

import 'package:orange/flows/wallet_flow/send_flow/confirm_send.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/util.dart';

class TransactionSpeed extends StatefulWidget {
  const TransactionSpeed({super.key});

  @override
  TransactionSpeedState createState() => TransactionSpeedState();
}

class TransactionSpeedState extends State<TransactionSpeed> {
  final TextEditingController recipientAddressController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultInterface(
      header: stackHeader(
        context,
        "Transaction speed",
      ),
      content: const Content(
        content: TransactionSpeedSelector(),
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          navigateTo(context, const ConfirmSend());
        },
      ),
    );
  }
}
