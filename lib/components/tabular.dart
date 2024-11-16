import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';

class SingleTab extends StatelessWidget {
  final String title;
  final String subtitle;

  const SingleTab({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.tab),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: CustomText(
              variant: 'text',
              font_size: 'sm',
              txt: title,
            ),
          ),
          const SizedBox(width: 8), 
          Flexible(
            flex: 1,
            child: CustomText(
              variant: 'text',
              font_size: 'sm',
              txt: subtitle,
              alignment: TextAlign.right, 
            ),
          ),
        ],
      ),
    );
  }
}
