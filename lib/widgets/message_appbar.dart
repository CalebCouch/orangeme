import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class MessageAppBar extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? showParticipants;

  const MessageAppBar({
    super.key,
    required this.title,
    this.imagePath = 'assets/images/default_profile.png',
    this.showParticipants,
  });

  @override
  Widget build(BuildContext context) {
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
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage(imagePath),
                          radius: 20,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          style: AppTextStyles.heading5,
                        ),
                      ],
                    ),
                  ),
                ),
                if (showParticipants == null) const SizedBox(width: 48),
                if (showParticipants != null)
                  IconButton(
                      icon: const Icon(Icons.info, color: AppColors.white),
                      onPressed: () => showParticipants!()),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
