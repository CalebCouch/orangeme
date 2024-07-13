import 'package:flutter/material.dart';

import 'package:orange/components/bumpers/bumper.dart';
import 'package:orange/components/text_input/text_input.dart';

class MessageBumper extends StatelessWidget {
  const MessageBumper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    return DefaultBumper(
      content: CustomTextInput(
        controller: messageController,
        hint: 'Message',
        isMessage: true,
      ),
    );
  }
}
