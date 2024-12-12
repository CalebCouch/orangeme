import 'package:flutter/material.dart';
import 'package:material/material.dart';

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    CustomTextTab(title),
                    SizedBox(width: 8),
                    CustomTextTab(subtitle, alignment: TextAlign.right),
                ],
            ),
        );
    }

    Widget CustomTextTab(String text, {TextAlign alignment = TextAlign.left}) {
        return Flexible(
            flex: 1,
            child: CustomText(variant: 'text', font_size: 'sm', txt: text, alignment: alignment),
        );
    }
}
