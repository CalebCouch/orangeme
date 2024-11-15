import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orangeme_material/color.dart';
import 'package:orangeme_material/icon.dart';
import 'package:orangeme_material/text.dart';

class ButtonColor {
  final String fill;
  final String text;

  const ButtonColor(this.fill, this.text);
}

Map buttonColors = {
  'primary': {
    'enabled': const ButtonColor('primary', 'color_handle'),
    'hovering': const ButtonColor('primary_hover', 'color_handle'),
    'disabled': const ButtonColor('text_secondary', 'handle'),
    'selected': const ButtonColor('primary', 'color_handle'),
  },
  'secondary': {
    'enabled': const ButtonColor('bg', 'color_handle'),
    'hovering': const ButtonColor('bg_secondary', 'color_handle'),
    'disabled': const ButtonColor('bg', 'text_secondary'),
    'selected': const ButtonColor('bg_secondary', 'color_handle'),
  },
  'ghost': {
    'enabled': const ButtonColor('bg', 'color_handle'),
    'hovering': const ButtonColor('bg_secondary', 'color_handle'),
    'disabled': const ButtonColor('bg', 'text_secondary'),
    'selected': const ButtonColor('bg_secondary', 'color_handle'),
  },
};

class CustomButton extends StatefulWidget {
  final String buttonData;
  final String txt;
  final VoidCallback onTap;
  final VoidCallback? onDis;
  final bool enabled;

  const CustomButton(this.txt, this.buttonData, this.onTap, this.enabled, {super.key, this.onDis});

  @override
  State<CustomButton> createState() => _ButtonState();
}

class _ButtonState extends State<CustomButton> {
  List<String> x = [];
  late Color fill;
  late String text;
  late String status;

  @override
  void initState() {
    status = widget.enabled ? 'enabled' : 'disabled';
    x = widget.buttonData.split(' ');
    super.initState();
  }

  Widget _displayIcon(y) {
    if (y.length == 4) {
      return Container(
        padding: EdgeInsets.only(right: y[1] == 'md' ? 8 : 12),
        child: CustomIcon("${y[3]} ${y[1]}"),
      );
    }
    return Container();
  }

  buzz() {
    if (widget.onDis != null) widget.onDis!();
    HapticFeedback.heavyImpact();
  }

  action() {
    HapticFeedback.heavyImpact();
    widget.onTap();
  }

  getColors() {
    text = buttonColors[x[0]][status].text;
    fill = customize_color[buttonColors[x[0]][status].fill]!;
  }

  Widget buildButton() {
    getColors();
    return InkWell(
      onHighlightChanged: (hovering) {
        setState(() {
          if (hovering) {
            // Change fill color when hovering/pressed
            if (widget.enabled) fill = customize_color[buttonColors[x[0]]['hovering']!.fill]!;
          } else {
            // Reset to the original color when not hovering/pressed
            fill = customize_color[buttonColors[x[0]][status].fill]!;
          }
        });
      },
      onTap: status == 'disabled' ? buzz : action,
      child: Container(
        key: UniqueKey(),
        height: button_size[x[1]],
        width: x[2] == 'expand' ? double.infinity : null,
        decoration: ShapeDecoration(
          color: fill,
          shape: x[0] == 'secondary' ? BoxDecorations.buttonOutlined : BoxDecorations.button,
        ),
        padding: EdgeInsets.symmetric(horizontal: x[1] == 'md' ? 12 : 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            x[3] == 'none' ? Container() : _displayIcon(x),
            CustomText('label ${x[1]} $text', widget.txt),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (x[2] == 'expand') return Flexible(child: buildButton());
    return buildButton();
  }
}

final Map<String, double> button_size = {
  'lg': 48,
  'md': 32,
};

class BoxDecorations {
  static RoundedRectangleBorder button = RoundedRectangleBorder(borderRadius: BorderRadius.circular(24));
  static RoundedRectangleBorder buttonOutlined = RoundedRectangleBorder(
    side: const BorderSide(
      width: 1,
      color: ThemeColor.outline,
    ),
    borderRadius: BorderRadius.circular(24),
  );
}
