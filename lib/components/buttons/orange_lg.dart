import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class ButtonOrangeLG extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isEnabled;

  const ButtonOrangeLG({
    super.key,
    required this.label,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<ButtonOrangeLG> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.isEnabled
        ? (_isHovering ? AppColors.orange : AppColors.orange)
        : AppColors.grey;

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
          constraints: const BoxConstraints(minWidth: 82, minHeight: 48),
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
                style: widget.isEnabled
                    ? AppTextStyles.labelLG
                    : AppTextStyles.labelLG.copyWith(color: AppColors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
