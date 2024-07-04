import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Button extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  final String? icon;
  final String variant;
  final String size;

  const Button(
      {super.key,
      required this.label,
      required this.variant,
      required this.size,
      this.onTap,
      this.enabled = true,
      this.icon});

  @override
  StatefulCustomButtonState createState() => StatefulCustomButtonState();
}

TextStyle labelStyle(String size, String variant, bool enabled) {
  var variantLower = variant.toLowerCase();
  var sizeLower = size.toLowerCase();
  if (variantLower == 'primary') {
    if (sizeLower == 'md') {
      return AppTextStyles.labelMD;
    } else if (sizeLower == 'lg') {
      return AppTextStyles.labelLG;
    }
  }
  if (variantLower == 'secondary' || variantLower == 'ghost') {
    if (sizeLower == 'md' && enabled) {
      return AppTextStyles.labelMD;
    } else if (sizeLower == 'md' && !enabled) {
      return AppTextStyles.labelLG.copyWith(color: AppColors.grey);
    }
    if (sizeLower == 'lg' && enabled) {
      return AppTextStyles.labelLG;
    } else if (sizeLower == 'lg' && !enabled) {
      return AppTextStyles.labelLG.copyWith(color: AppColors.grey);
    }
  }
  if (variantLower == 'bitcoin') {
    if (sizeLower == 'md' && enabled) {
      return AppTextStyles.labelMD;
    } else if (sizeLower == 'md' && !enabled) {
      return AppTextStyles.labelMD.copyWith(color: AppColors.black);
    }
    if (sizeLower == 'lg' && enabled) {
      return AppTextStyles.labelLG;
    } else if (sizeLower == 'lg' && !enabled) {
      return AppTextStyles.labelLG.copyWith(color: AppColors.black);
    }
  }
  //default case
  return AppTextStyles.labelMD;
}

Color buttonStyle(String variant, bool enabled, bool isHovering) {
  var variantLower = variant.toLowerCase();
  if (variantLower == 'secondary' || variantLower == 'ghost') {
    if (isHovering) {
      return AppColors.darkGrey;
    } else {
      return AppColors.black;
    }
  } else {
    if (enabled) {
      if (variantLower == 'primary') {
        return AppColors.white;
      } else {
        return AppColors.orange;
      }
    } else {
      return AppColors.grey;
    }
  }
}

Color borderVariant(String variant) {
  var variantLower = variant.toLowerCase();
  if (variantLower == "secondary") {
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
        onTap: widget.enabled ? widget.onTap : null,
        onHover: (hovering) {
          setState(() => _isHovering = hovering);
        },
        borderRadius: AppBorders.buttonBorderRadius,
        child: Container(
          padding: AppPadding.buttonInsetPadding,
          decoration: ShapeDecoration(
            color: buttonStyle(widget.variant, widget.enabled, _isHovering),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: borderVariant(widget.variant)),
              borderRadius: AppBorders.buttonBorderRadius,
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
                                style: labelStyle(widget.size, widget.variant,
                                    widget.enabled)),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      style: labelStyle(
                          widget.size, widget.variant, widget.enabled),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
