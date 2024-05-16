import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class ButtonGhostLG extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isEnabled;

  const ButtonGhostLG({
    super.key,
    required this.label,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  CustomStatefulButtonState createState() => CustomStatefulButtonState();
}

class CustomStatefulButtonState extends State<ButtonGhostLG> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.isEnabled
        ? (_isHovering ? AppColors.offBlack : Colors.transparent)
        : Colors.transparent;

    return Material(
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: widget.isEnabled ? widget.onTap : null,
        onHover: (hovering) {
          setState(() => _isHovering = hovering);
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 82,
          height: 48,
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
                    : AppTextStyles.labelLG.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
