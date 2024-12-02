import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orangeme_material/color.dart';
import 'package:orangeme_material/icon.dart';
import 'package:orangeme_material/text.dart';

class CustomButton extends StatefulWidget {
    final String txt;
    final String variant;
    final String size;
    final bool expand;
    final String? icon;
    final VoidCallback onTap;
    final VoidCallback? onDis;
    final bool enabled;
    final String? color;

    const CustomButton({
            super.key, 
            this.variant = 'primary',
            this.size = 'lg',
            this.onDis,
            this.icon,
            this.expand = true,
            required this.txt,
            required this.onTap, 
            this.enabled = true, 
            this.color,
        }
    );

    @override
    State<CustomButton> createState() => _ButtonState();
}

class _ButtonState extends State<CustomButton> {
    late Color fill;
    late String text;
    late String status;

    Widget _displayIcon() {
        return Container(
            padding: EdgeInsets.only(right: widget.size == 'md' ? 8 : 12),
            child: CustomIcon(icon: widget.icon!, size: widget.size),
        );
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
        setState(() => status = widget.enabled ? 'enabled' : 'disabled');
        text = buttonColors[widget.variant][status].text;
        fill = customize_color[widget.color ?? buttonColors[widget.variant][status].fill]!;
    }

    Widget buildButton() {
        getColors();
        return InkWell(
            onHighlightChanged: (hovering) {
                setState(() {
                    if (hovering) {
                        if (widget.enabled) fill = customize_color[buttonColors[widget.variant]['hovering']!.fill]!;
                    } else {
                        fill = customize_color[buttonColors[widget.variant][status].fill]!;
                    }
                });
            },
            onTap: status == 'disabled' ? buzz : action,
            child: Container(
                key: UniqueKey(),
                height: button_size[widget.size],
                width: widget.expand  ? double.infinity : null,
                decoration: ShapeDecoration(
                    color: fill,
                    shape: widget.variant == 'secondary' ? BoxDecorations.buttonOutlined : BoxDecorations.button,
                ),
                padding: EdgeInsets.symmetric(horizontal: widget.size == 'md' ? 12 : 16),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        widget.icon == null ? Container() : _displayIcon(),
                        CustomText(txt: widget.txt, variant: 'label', font_size: widget.size, text_color: text),
                    ],
                ),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        return widget.expand ? Flexible(child: buildButton()) : buildButton();
    }
}

final Map<String, double> button_size = {
    'lg': 48,
    'md': 32,
};

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


// CUSTOM BUTTONS //

class CopyButton extends CustomButton {
  final String textToCopy;

  CopyButton({required this.textToCopy, Key? key})
      : super(
          txt: 'Copy',
          variant: 'secondary',
          size: 'md',
          expand: false,
          icon: 'copy',
          onTap: () {},
          color: 'bg', // Default color
        );

  @override
  _CopyButtonState createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  String buttonText = 'Copy';
  String buttonColor = 'bg'; 

  copyDid() async {
    HapticFeedback.heavyImpact();
    await Clipboard.setData(ClipboardData(text: widget.textToCopy));

    setState(() {
      buttonText = 'Copied';
      buttonColor = 'bg_secondary';
    });

    await Future.delayed(Duration(seconds: 2));
    setState(() {
      buttonText = 'Copy';
      buttonColor = 'bg'; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      txt: buttonText,
      variant: 'secondary',
      size: 'md',
      expand: false,
      icon: 'copy',
      onTap: copyDid,
      color: buttonColor, 
    );
  }
}
