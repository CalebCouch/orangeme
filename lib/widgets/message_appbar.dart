import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';

class MessageAppBar extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? showRecipients;
  final List<String> recipients;
  const MessageAppBar({
    super.key,
    required this.title,
    required this.recipients,
    this.imagePath = 'assets/images/default_profile.png',
    this.showRecipients,
  });
  @override
  Widget build(BuildContext context) {
    int avatarCount = math.min(5, recipients.length);
    double radius = 20;
    double overlap = 10;
    double totalWidth = 2 * radius + (avatarCount - 1) * (2 * radius - overlap);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.background,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: SvgPicture.asset(AppIcons.left, width: 32, height: 32),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (recipients.length == 1)
                          CircleAvatar(
                            backgroundImage: AssetImage(imagePath),
                            radius: radius,
                          )
                        else if (recipients.isNotEmpty)
                          Center(
                            child: SizedBox(
                              height: 2 * radius,
                              width: totalWidth,
                              child: Stack(
                                children: List.generate(
                                  avatarCount,
                                  (index) => Positioned(
                                    left: index * (2 * radius - overlap),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(imagePath),
                                      radius: radius,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          style: AppTextStyles.heading5,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                if (showRecipients != null)
                  IconButton(
                    icon: SvgPicture.asset(AppIcons.info, width: 32, height: 32),
                    onPressed: showRecipients,
                  ),
                if (showRecipients == null) const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
