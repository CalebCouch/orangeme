import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/buttons/icon_button.dart';
import 'package:orange/components/custom/custom_text.dart';

class CustomTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? title;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final bool showNewLine;
  final String error;
  final bool isMessage;

  const CustomTextInput({
    super.key,
    required this.controller,
    this.title,
    this.hint = 'Enter the text here',
    this.onChanged,
    this.onEditingComplete,
    this.showNewLine = false,
    this.error = 'error',
    this.isMessage = false,
  });

  @override
  CustomTextInputState createState() => CustomTextInputState();
}

class CustomTextInputState extends State<CustomTextInput> {
  late Color borderColor;
  late Color textColor;
  late Color errorMessageColor;
  late String errorMessage;
  late bool isFocused;

  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    borderColor = ThemeColor.outline;
    textColor = ThemeColor.primary;
    errorMessageColor = Colors.transparent;
    errorMessage = '';
    isFocused = false;
    focusNode = FocusNode();
    focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(
      () {
        isFocused = focusNode.hasFocus;
        borderColor = isFocused ? ThemeColor.primary : ThemeColor.outline;
        textColor = ThemeColor.primary;
        errorMessageColor = Colors.transparent;
        errorMessage = '';

        if (!isFocused && widget.controller.text.isEmpty) {
          borderColor = ThemeColor.outline;
        }
      },
    );
  }

  Widget _buildTextField() {
    return Expanded(
      child: TextField(
        maxLines: null,
        controller: widget.controller,
        focusNode: focusNode,
        cursorWidth: 2.0,
        cursorColor: ThemeColor.textSecondary,
        style: TextStyle(color: textColor),
        onChanged: widget.onChanged,
        textInputAction: widget.showNewLine == true
            ? TextInputAction.newline
            : TextInputAction.done,
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
        widget.title != null ? titleText(widget.title!) : Container(),
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
                widget.isMessage
                    ? CustomSendButton(
                        onTap: widget.onEditingComplete, isEnabled: true)
                    : Container(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: CustomText(
            text: errorMessage,
            textType: "text",
            textSize: TextSize.sm,
            color: ThemeColor.danger,
          ),
        ),
      ],
    );
  }
}

Widget titleText(String text) {
  return Container(
    padding: const EdgeInsets.only(bottom: 16),
    child: CustomText(
      text: text,
      textType: 'heading',
      textSize: TextSize.h5,
    ),
  );
}
