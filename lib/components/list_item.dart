import 'package:flutter/material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
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
                                    if (title != null) CustomText(
                                        variant: 'heading', 
                                        font_size: 'h5', 
                                        txt: title!
                                    ),
                                    if (sub != null) CustomText(
                                        variant:'text', 
                                        font_size: 'sm', 
                                        txt: sub!,
                                        max_lines: 2,
                                        alignment: TextAlign.left
                                    ),
                                    if (desc != null) CustomText(
                                        variant: 'text', 
                                        font_size: 'sm', 
                                        text_color: 'text_secondary', 
                                        txt: desc!, 
                                        alignment: TextAlign.left
                                    ),
                                ], 4, true, false),
                            ),
                        ),
                        if (titleR != null) const Spacing(16),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            if (titleR != null) CustomText(
                                variant: 'heading',
                                font_size: 'h5', 
                                txt: titleR!, 
                                alignment: TextAlign.right
                            ),
                            const Spacing(4),
                            if (subR != null) CustomText(
                                variant: 'text',
                                font_size: 'sm', 
                                txt: subR!, 
                                text_decoration: TextDecoration.underline,
                                alignment: TextAlign.right,
                            ),
                        ]),
                        if (caret) const Spacing(16),
                        if (caret) const CustomIcon(icon: 'forward', size: 'md'),
                    ],
                ),
            ),
        );
    }
}

Widget ContactItem(BuildContext context, DartProfile contact, onTap) {
    return ListItem(
        onTap: onTap,
        visual: ProfilePhoto(context, pfp: contact.pfpPath, size: ProfileSize.lg),
        title: contact.name,
        sub: EllipsisText(contact.did),
        caret: false,
    );
}
