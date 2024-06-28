import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? rightIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final bool showNewLine;
  final bool submitEnabled;
  final String error;

  const TextInputField({
    super.key,
    required this.controller,
    this.hint = 'Enter the text here',
    this.rightIcon,
    this.onChanged,
    this.onEditingComplete,
    this.showNewLine = false,
    this.submitEnabled = false,
    this.error = 'error',
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
      borderColor = isFocused ? AppColors.primary : AppColors.darkGrey;
      textColor = AppColors.primary;
      errorMessageColor = Colors.transparent;
      errorMessage = '';

      if (!isFocused && widget.controller.text.isEmpty) {
        borderColor = AppColors.darkGrey;
      }
      //we are not currently using this error text anywhere, consider removing
      // else if (!isFocused &&
      //     widget.controller.text.isNotEmpty &&
      //     widget.controller.text != 'Value') {
      //   borderColor = AppColors.danger;
      //   textColor = AppColors.danger;
      //   errorMessage = widget.error;
      //   errorMessageColor = AppColors.danger;
      // }
    });
  }

  Widget _buildTextField() {
    return Expanded(
      child: TextField(
        maxLines: null,
        controller: widget.controller,
        focusNode: focusNode,
        cursorWidth: 2.0,
        cursorColor: AppColors.grey,
        style: TextStyle(color: textColor),
        onChanged: widget.onChanged,
        textInputAction: widget.showNewLine == true
            ? TextInputAction.newline
            : TextInputAction.done,
        decoration: InputDecoration(
          hintText: isFocused ? '' : widget.hint,
          hintStyle: const TextStyle(color: AppColors.outline),
          border: InputBorder.none,
          filled: true,
          fillColor: AppColors.black,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    double iconSize = 32;
    Color iconColor = widget.submitEnabled ? AppColors.white : AppColors.grey;
    return Center(
      child: IconButton(
        icon: SvgPicture.asset(AppIcons.send,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            width: 32,
            height: 32),
        iconSize: iconSize,
        onPressed: widget.submitEnabled ? widget.onEditingComplete : null,
      ),
    );
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
            child: Row(
              children: [
                _buildTextField(),
                widget.rightIcon != null
                    ? _buildSubmitButton()
                    : const SizedBox(height: 0),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            errorMessage,
            style: TextStyle(color: errorMessageColor),
          ),
        ),
      ],
    );
  }
}
