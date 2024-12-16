import 'package:material/material.dart';
import 'package:material/navigation.dart';

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
    late ButtonState status = ButtonState.enabled;

    checkState(){ 
        setState(() {
            if(status != ButtonState.hover) status = widget.enabled ? ButtonState.enabled : ButtonState.disabled;
        }); 
    }

    hover(bool hovering){
        setState(() {
            if (hovering && status == ButtonState.enabled) status = ButtonState.hover;
        });
    }

    buzz() {
        if (widget.onDis != null) widget.onDis!();
        HapticFeedback.heavyImpact();
    }

    action() {
        HapticFeedback.heavyImpact();
        widget.onTap();
    }

    tapped(){ status == ButtonState.disabled ? buzz : action; }
    getColors(){ return buttonColors[widget.variant][status]; }   
    width(){ return widget.expand ? double.infinity : null; }
    height(){ return widget.size == 'lg' ? 48.0 : 32.0; }
    padding(){ return EdgeInsets.symmetric(horizontal: h_padding[widget.size]!); }

    Widget _displayIcon() {
        return Container(
            padding: EdgeInsets.only(right: i_padding[widget.size]!),
            child: CustomIcon(icon: widget.icon!, size: widget.size),
        );
    }

    Widget buildButton() {
        checkState();
        var colors = getColors();

        return InkWell(
            onHighlightChanged: (hovering) => hover(hovering),
            onTap: tapped,
            child: Container(
                key: UniqueKey(),

                padding: padding(),
                height: height(),
                width: width(),

                decoration: ShapeDecoration(
                    color: colors.background,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: colors.outline),
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                    )
                ),
                
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        widget.icon == null ? Container() : _displayIcon(),
                        CustomText(txt: widget.txt, variant: 'label', font_size: widget.size, text_color: colors.label),
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

final Map<String, double> h_padding = {
    'lg' : 16,
    'md' : 12,
};

final Map<String, double> i_padding = {
    'lg' : 12,
    'md' : 8,
};

enum ButtonState {
    enabled,
    selected,
    hover,
    disabled,
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
            color: 'bg',
        );

    @override
    _CopyButtonState createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
    String buttonText = 'Copy';
    String buttonColor = 'bg';

    void _copyText() async {
        HapticFeedback.heavyImpact();
        await Clipboard.setData(ClipboardData(text: widget.textToCopy));

        setState(() {
            buttonText = 'Copied';
            buttonColor = 'bg_secondary';
        });

        await Future.delayed(const Duration(seconds: 2));
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
            onTap: _copyText,
            color: buttonColor,
        );
    }
}