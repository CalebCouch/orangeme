import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeadingStack extends StatefulWidget {
  final String label;
  final VoidCallback? onDashboardPopBack;

  const HeadingStack({
    super.key,
    required this.label,
    this.onDashboardPopBack
  });

  @override
  CustomHeadingState createState() => CustomHeadingState();
}

class CustomHeadingState extends State<HeadingStack> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align (
          alignment: Alignment.centerLeft,
          child: Padding (
            padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: SvgPicture.asset(AppIcons.left, width: 32, height: 32),
              onPressed: () {
                widget.onDashboardPopBack!();
                Navigator.pop(context);
              }
            ),
          ),
        ),
        Container (
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: AppTextStyles.heading4
          ),
        )
      ]
    );
  }
}

