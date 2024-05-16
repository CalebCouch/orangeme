import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class ButtonSecondaryMD extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isEnabled;

  const ButtonSecondaryMD({
    super.key,
    required this.label,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  StatefulCustomButtonState createState() => StatefulCustomButtonState();
}

class StatefulCustomButtonState extends State<ButtonSecondaryMD> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.isEnabled ? widget.onTap : null,
        onHover: (hovering) {
          setState(() => _isHovering = hovering);
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 64,
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            color: _isHovering
                ? AppColors.white.withOpacity(0.15)
                : Colors.transparent,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: AppColors.darkGrey),
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
                style: AppTextStyles.labelMD,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
