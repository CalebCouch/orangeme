import 'package:flutter/material.dart';
import 'package:orange/classes.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/util.dart';
import 'package:orangeme_material/orangeme_material.dart';

class ListItem extends StatelessWidget {
  final Widget? visual;
  final String? title;
  final String? sub;
  final String? desc;
  final String? titleR;
  final String? subR;
  final VoidCallback? onTap;
  final bool caret;

  const ListItem({
    super.key,
    this.visual,
    this.title,
    this.sub,
    this.desc,
    this.titleR,
    this.subR,
    this.onTap,
    this.caret = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppPadding.listItem),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (visual != null) visual!,
            if (visual != null) const Spacing(16),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: CustomColumn([
                  if (title != null) CustomText('heading h5', title!),
                  if (sub != null) CustomText('text sm', sub!),
                  if (desc != null) CustomText('text sm text_secondary', desc!, alignment: TextAlign.left),
                ], 4, true, false),
              ),
            ),
            if (titleR != null) const Spacing(16),
            CustomColumn([
              if (titleR != null) CustomText('heading h5', titleR!),
              if (subR != null) CustomText('text sm', subR!, underline: true),
            ], 4),
            const Spacing(16),
            if (caret) const CustomIcon('forward md'),
          ],
        ),
      ),
    );
  }
}

Widget ContactItem(BuildContext context, Contact contact, onTap) {
  return ListItem(
    onTap: onTap,
    visual: ProfilePhoto(context, contact.pfp, ProfileSize.lg),
    title: contact.name,
    sub: middleCut(contact.did, 30),
    caret: false,
  );
}
