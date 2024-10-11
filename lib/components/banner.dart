import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orangeme_material/orangeme_material.dart';

class CustomBanner extends StatefulWidget {
  final String message;
  final bool isError;

  const CustomBanner(
    this.message, {
    super.key,
    this.isError = false,
  });

  @override
  CustomBannerState createState() => CustomBannerState();
}

class CustomBannerState extends State<CustomBanner> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    final parts = widget.message.contains("orange.me") ? widget.message.split('orange.me') : null;

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
                      'text sm heading',
                      widget.message,
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
              () {
                setState(() {
                  _isVisible = false;
                });
              },
              'close md',
            ),
          ),
        Positioned(
          right: 0,
          child: CustomIcon('${widget.isError ? 'error' : 'info'} lg'),
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
