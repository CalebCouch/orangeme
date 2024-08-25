import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/util.dart';

// A customizable banner that shows a message with optional error styling and a
// close button, adjusting display based on the message content and banner type.

class CustomBanner extends StatefulWidget {
  final String message;
  final bool isError;

  const CustomBanner({
    super.key,
    required this.message,
    this.isError = false,
  });

  @override
  CustomBannerState createState() => CustomBannerState();
}

class CustomBannerState extends State<CustomBanner> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isVisible,
      child: Container(
        padding: const EdgeInsets.only(bottom: AppPadding.content),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: ThemeColor.border),
            bottom: BorderSide(width: 1, color: ThemeColor.border),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.banner),
          child: Column(
            children: [
              _buildBannerHeader(),
              const SizedBox(height: AppPadding.banner),
              widget.message.contains('orange.me')
                  ? buildTextWithBrandMark(
                      widget.message, TextSize.sm, FontWeight.w400)
                  : CustomText(
                      text: widget.message,
                      color: ThemeColor.heading,
                      textSize: TextSize.sm,
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerHeader() {
    return Stack(
      children: [
        if (!widget.isError)
          Positioned(
            left: 0,
            child: iconButton(
              context,
              () {
                setState(() {
                  _isVisible = false;
                });
              },
              const CustomIcon(
                iconSize: IconSize.md,
                icon: ThemeIcon.close,
              ),
            ),
          ),
        Positioned(
          right: 0,
          child: CustomIcon(
            iconSize: IconSize.lg,
            icon: widget.isError ? ThemeIcon.error : ThemeIcon.info,
          ),
        ),
      ],
    );
  }
}
