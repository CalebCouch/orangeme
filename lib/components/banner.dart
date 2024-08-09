import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/custom/custom_text.dart';

class CustomBanner extends StatefulWidget {
  final String message;
  final bool isError;
  final bool isDismissable;

  const CustomBanner({
    super.key,
    required this.message,
    this.isError = false,
    this.isDismissable = false,
  });
  @override
  BannerState createState() => BannerState();
}

class BannerState extends State<CustomBanner> {
  bool show = true;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: show,
      child: Container(
        padding: const EdgeInsets.only(bottom: AppPadding.content),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 1, color: ThemeColor.border),
              bottom: BorderSide(width: 1, color: ThemeColor.border),
            ),
          ),
          padding: const EdgeInsets.all(AppPadding.banner),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: !widget.isError && widget.isDismissable
                        ? iconButton(
                            context,
                            () {
                              setState(() {
                                show = false;
                              });
                            },
                            const CustomIcon(
                                iconSize: IconSize.md, icon: ThemeIcon.close),
                          )
                        : Container(),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: widget.isError
                        ? const CustomIcon(
                            iconSize: IconSize.lg, icon: ThemeIcon.error)
                        : const CustomIcon(
                            iconSize: IconSize.lg, icon: ThemeIcon.info),
                  ),
                ],
              ),
              const Spacing(height: AppPadding.banner),
              widget.message.contains("orange.me")
                  ? withBrandMark(widget.message.split('orange.me'))
                  : CustomText(
                      text: widget.message,
                      color: ThemeColor.heading,
                      textSize: TextSize.md,
                    )
            ],
          ),
        ),
      ),
    );
  }
}

Widget withBrandMark(parts) {
  return Text.rich(
    textAlign: TextAlign.center,
    TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: parts[0],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: ThemeColor.heading,
          ),
        ),
        const TextSpan(
          text: 'orange',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: ThemeColor.bitcoin,
          ),
        ),
        const TextSpan(
          text: '.me',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: ThemeColor.heading,
          ),
        ),
        TextSpan(
          text: parts[1],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: ThemeColor.heading,
          ),
        ),
      ],
    ),
  );
}
