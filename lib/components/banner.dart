import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/custom/custom_text.dart';

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
    final parts = widget.message.contains("orange.me")
        ? widget.message.split('orange.me')
        : null;

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
              parts == null
                  ? CustomText(
                      text: widget.message,
                      color: ThemeColor.heading,
                      textSize: TextSize.sm,
                    )
                  : _buildTextWithBrandMark(parts),
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

  Widget _buildTextWithBrandMark(List<String> parts) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: parts[0],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: ThemeColor.heading,
            ),
          ),
          const TextSpan(
            text: 'orange',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: ThemeColor.primary,
            ),
          ),
          const TextSpan(
            text: '.me',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: ThemeColor.heading,
            ),
          ),
          TextSpan(
            text: parts[1],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: ThemeColor.heading,
            ),
          ),
        ],
      ),
    );
  }
}
