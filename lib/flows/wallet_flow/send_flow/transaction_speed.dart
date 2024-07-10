import 'package:flutter/material.dart';

import 'package:orange/components/interfaces/default_interface.dart';
import 'package:orange/components/list_selector/transaction_speed_selector.dart';

import 'package:orange/flows/wallet_flow/send_flow/confirm_send.dart';

import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_header.dart';
import 'package:orange/components/bumpers/single_button_bumper.dart';
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
      header: const StackHeader(
        text: "Transaction speed",
      ),
      content: const Content(
        content: TransactionSpeedSelector(),
      ),
      bumper: SingleButton(
        text: "Continue",
        onTap: () {
          navigateTo(context, const ConfirmSend());
        },
      ),
    );
  }
}
