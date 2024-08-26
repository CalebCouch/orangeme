import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/custom/custom_text.dart';

// A customizable text input field widget that supports optional icons, error
// messages, and various callback functions for text changes, submission, and completion.

class CustomTextInput extends StatefulWidget {
  final String hint;
  final String? title;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final bool showIcon;
  final String error;
  final String? presetTxt;
  final TextEditingController? controller;

  const CustomTextInput({
    super.key,
    this.title,
    this.hint = 'Enter the text here',
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.showIcon = false,
    this.error = '',
    this.presetTxt,
    this.controller,
  });

  @override
  CustomTextInputState createState() => CustomTextInputState();
}

class CustomTextInputState extends State<CustomTextInput> {
  late TextEditingController controller;
  var borderColor = ThemeColor.outline;
  var textColor = ThemeColor.secondary;
  var isFocused = false;
  var focusNode = FocusNode();
  bool iconEnabled = true;

  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? TextEditingController(text: widget.presetTxt);
    if (widget.showIcon == true) iconEnabled = false;
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
      borderColor = isFocused ? ThemeColor.secondary : ThemeColor.outline;
      textColor = ThemeColor.secondary;
      if (!isFocused && controller.text.isEmpty) {
        borderColor = ThemeColor.outline;
      }
    });
  }

  Future<void> iconStatus(String text) async {
    setState(() {
      if (text == '') {
        iconEnabled = false;
      } else {
        iconEnabled = true;
      }
    });
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
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    cursorWidth: 2.0,
                    cursorColor: ThemeColor.textSecondary,
                    style: TextStyle(color: textColor),
                    onChanged: widget.showIcon
                        ? (String text) => iconStatus(text)
                        : widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    onEditingComplete: widget.onEditingComplete,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: const TextStyle(color: ThemeColor.outline),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: ThemeColor.bg,
                    ),
                  ),
                ),
                widget.showIcon
                    ? sendButton(context, iconEnabled)
                    : Container(),
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
