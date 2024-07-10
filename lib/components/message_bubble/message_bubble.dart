import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/theme/stylesheet.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isReceived;
  final bool isGroup;
  final String time;
  final String name;

  const MessageBubble({
    super.key,
    required this.text,
    this.isReceived = true,
    this.isGroup = false,
    required this.time,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isReceived ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Container(
          decoration: ShapeDecoration(
            color: isReceived ? ThemeColor.bgSecondary : ThemeColor.bitcoin,
            shape: RoundedRectangleBorder(
              borderRadius: ThemeBorders.messageBubble,
            ),
          ),
          constraints: const BoxConstraints(maxWidth: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: CustomText(
            text: text,
            textSize: TextSize.md,
            alignment: isReceived ? TextAlign.left : TextAlign.right,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: isReceived ? Alignment.centerLeft : Alignment.centerRight,
          child: Row(
            mainAxisAlignment:
                isReceived ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              isReceived && isGroup
                  ? CustomText(
                      text: '$name ·',
                      color: ThemeColor.textSecondary,
                      textSize: TextSize.sm,
                    )
                  : Container(),
              CustomText(
                text: time,
                color: ThemeColor.textSecondary,
                textSize: TextSize.sm,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
