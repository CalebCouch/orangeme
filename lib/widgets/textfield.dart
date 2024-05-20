import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;

  const TextInputField({
    super.key,
    required this.controller,
    this.hint = 'Enter the text here',
    this.onChanged,
    this.onEditingComplete,
  });

  @override
  TextInputFieldState createState() => TextInputFieldState();

}

class TextInputFieldState extends State<TextInputField> {
  late Color borderColor;
  late Color textColor;
  late Color errorMessageColor;
  late String errorMessage;
  late bool isFocused;

  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    borderColor = AppColors.darkGrey;
    textColor = AppColors.primary;
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
    setState(() {
      isFocused = focusNode.hasFocus;
      if (!isFocused && widget.controller.text.isEmpty) {
        borderColor = AppColors.darkGrey;
        textColor = AppColors.primary;
      } else if (!isFocused &&
          widget.controller.text.isNotEmpty &&
          widget.controller.text != 'Value') {
        borderColor = AppColors.danger;
        textColor = AppColors.danger;
        errorMessage = 'Error message';
        errorMessageColor = AppColors.danger;
      } else {
        borderColor = AppColors.darkGrey;
        textColor = AppColors.primary;
        errorMessage = '';
        errorMessageColor = Colors.transparent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: widget.controller,
              focusNode: focusNode,
              cursorWidth: 2.0,
              cursorColor: AppColors.grey, 
              style: TextStyle(color: textColor),
              onChanged: (value) {
                setState(() {
                  errorMessage = '';
                  errorMessageColor = Colors.transparent;
                });
                widget.onChanged?.call(value);
              },
              decoration: InputDecoration(
                hintText: isFocused ? '' : widget.hint,
                hintStyle: const TextStyle(
                  color: AppColors.outline,
                ),
                border: InputBorder.none,
                filled: true,
                fillColor: AppColors.black,
              ),
              onEditingComplete: widget.onEditingComplete,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 8.0),
          child: Text(
            errorMessage,
            style: TextStyle(color: errorMessageColor),
          ),
        ),
      ],
    );
  }
}

