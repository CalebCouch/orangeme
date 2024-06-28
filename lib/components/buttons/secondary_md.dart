import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonSecondaryMD extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isEnabled;
  final String? icon;

  const ButtonSecondaryMD(
      {super.key,
      required this.label,
      this.onTap,
      this.isEnabled = true,
      this.icon});

  @override
  StatefulCustomButtonState createState() => StatefulCustomButtonState();
}

class StatefulCustomButtonState extends State<ButtonSecondaryMD> {
  bool _isHovering = false;

  /* IconData getIconFromString(String? iconName) {
    if (iconName == null) {
      return Icons.error;
    }
    switch (iconName.toLowerCase()) {
      case 'clipboard':
        return Icons.content_paste;
      case 'qrcode':
        return Icons.qr_code_sharp;
      case 'edit':
        return Icons.create_outlined;
      case 'clear':
        return Icons.clear;
      default:
        return Icons.error;
    }
  }*/

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
          constraints: const BoxConstraints(minWidth: 64, minHeight: 32),
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
              widget.icon != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(widget.icon!, width: 20, height: 20),
                        const SizedBox(width: 8),
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text: widget.label,
                                style: AppTextStyles.labelMD),
                          ),
                        ),
                      ],
                    )
                  : Text(
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
