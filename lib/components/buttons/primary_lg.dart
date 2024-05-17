import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class ButtonPrimaryLG extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isEnabled;

  const ButtonPrimaryLG({
    super.key,
    required this.label,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<ButtonPrimaryLG> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.isEnabled
        ? (_isHovering ? AppColors.white : AppColors.white)
        : AppColors.grey;

    TextStyle textStyle = AppTextStyles.labelLG;

    return Material(
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: widget.isEnabled ? widget.onTap : null,
        onHover: (value) {
          setState(() {
            _isHovering = value;
          });
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
