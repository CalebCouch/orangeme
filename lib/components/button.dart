import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Button extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isEnabled;
  final String? icon;
  final String variant;
  final String size;

  const Button(
      {super.key,
      required this.label,
      required this.variant,
      required this.size,
      this.onTap,
      this.isEnabled = true,
      this.icon});

  @override
  StatefulCustomButtonState createState() => StatefulCustomButtonState();
}

TextStyle labelSize(String size) {
  if (size == 'MD') {
    return AppTextStyles.labelMD;
  } else if (size == 'LG') {
    return AppTextStyles.labelLG;
  } else {
    return AppTextStyles.labelMD;
  }
}

Color buttonVariant(String variant, bool isEnabled, bool isHovering) {
  if ((variant == "secondary" || variant == 'ghost') &&
      isEnabled &&
      isHovering) {
    return AppColors.darkGrey;
  } else if ((variant == "secondary" || variant == 'ghost') && !isEnabled) {
    return AppColors.black;
  } else if (variant == "secondary" || variant == 'ghost') {
    return AppColors.black;
  } else if (variant == 'primary' && isEnabled) {
    return AppColors.white;
  } else if (variant == 'primary') {
    return AppColors.grey;
  } else if (variant == 'bitcoin' && isEnabled) {
    return AppColors.orange;
  } else if (variant == 'bitcoin') {
    return AppColors.grey;
  } else {
    return Colors.transparent;
  }
}

Color borderVariant(String variant) {
  if (variant == "secondary") {
    return AppColors.darkGrey;
  } else {
    return Colors.transparent;
  }
}

class StatefulCustomButtonState extends State<Button> {
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
          constraints: const BoxConstraints(minWidth: 64, minHeight: 32),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            color: buttonVariant(widget.variant, widget.isEnabled, _isHovering),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: borderVariant(widget.variant)),
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
                                style: labelSize(widget.size)),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      style: labelSize(widget.size),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
