import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/bumper.dart';

class CustomTextInput extends StatefulWidget {
  final String hint;
  final String? title;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final bool showIcon;
  final String error;
  final String? address;
  final TextEditingController? controller;

  const CustomTextInput({
    super.key,
    this.title,
    this.hint = 'Enter the text here',
    this.onChanged,
    this.onEditingComplete,
    this.showIcon = false,
    this.error = '',
    this.address,
    this.controller,
  });

  @override
  CustomTextInputState createState() => CustomTextInputState();
}

class CustomTextInputState extends State<CustomTextInput> {
  late TextEditingController controller;
  var borderColor = ThemeColor.outline;
  var textColor = ThemeColor.primary;
  var isFocused = false;
  var focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    focusNode.dispose();
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      isFocused = focusNode.hasFocus;
      borderColor = isFocused ? ThemeColor.primary : ThemeColor.outline;
      textColor = ThemeColor.primary;
      if (!isFocused && controller.text.isEmpty) {
        borderColor = ThemeColor.outline;
      }
    });
  }

  Widget _buildTextField() {
    if (widget.address != null && widget.address != '') {
      controller.text = widget.address!;
    }
    return Expanded(
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        cursorWidth: 2.0,
        cursorColor: ThemeColor.textSecondary,
        style: TextStyle(color: textColor),
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: isFocused ? '' : widget.hint,
          hintStyle: const TextStyle(color: ThemeColor.outline),
          border: InputBorder.none,
          filled: true,
          fillColor: ThemeColor.bg,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title != null
            ? Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomText(
                  text: widget.title!,
                  textType: 'heading',
                  textSize: TextSize.h5,
                ),
              )
            : Container(),
        Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: borderColor,
              ),
              borderRadius: ThemeBorders.textInput,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppPadding.textInput),
            child: Row(
              children: [
                _buildTextField(),
                widget.showIcon ? sendButton(context, true) : Container(),
              ],
            ),
          ),
        ),
        widget.error != ''
            ? Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CustomText(
                  text: widget.error,
                  textType: "text",
                  textSize: TextSize.sm,
                  color: ThemeColor.danger,
                ),
              )
            : Container(),
      ],
    );
  }
}

Widget messageInput() {
  return const DefaultBumper(
    content: CustomTextInput(
      hint: 'Message',
      showIcon: true,
    ),
  );
}
