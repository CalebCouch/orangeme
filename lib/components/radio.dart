import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:tuple/tuple.dart';

class ListSelector extends StatelessWidget {
    final Tuple2<String, String> one;
    final Tuple2<String, String> two;
    final int currentIndex;
    final ValueChanged<int> onIndexChanged;

    const ListSelector({
        required this.one,
        required this.two,
        required this.currentIndex,
        required this.onIndexChanged,
        Key? key,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                RadioButton(
                    title: one.item1,
                    subtitle: one.item2,
                    isSelected: currentIndex == 0,
                    onTap: () => onIndexChanged(0),
                ),
                RadioButton(
                    title: two.item1,
                    subtitle: two.item2,
                    isSelected: currentIndex == 1,
                    onTap: () => onIndexChanged(1),
                ),
            ],
        );
    }
}

Widget RadioButton({required String title, required String subtitle, required bool isSelected, required onTap}) {
    return InkWell(
        onTap: () { HapticFeedback.heavyImpact(); onTap(); },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    CustomIcon(
                        icon: isSelected ? 'radioFilled' : 'radio', 
                        size: 'lg', 
                        key: UniqueKey()
                    ),
                    const Spacing(16),
                    Expanded(
                        child: CustomColumn([
                            CustomText(
                                variant: 'heading', 
                                font_size: 'h5', 
                                txt: title, 
                                alignment: TextAlign.left
                            ),
                            CustomText(
                                variant: 'text',
                                font_size: 'sm',
                                text_color: 'text_secondary', 
                                txt: subtitle, 
                                alignment: TextAlign.left
                            ),
                        ], 8, true, false),
                    ),
                ],
            ),
        ),
    );
}