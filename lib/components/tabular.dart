import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';
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
                    CustomText(variant: 'text', font_size: 'sm', txt: title),
                    CustomText(variant: 'text', font_size: 'sm', txt: subtitle),
                ],
            ),
        );
    }
}