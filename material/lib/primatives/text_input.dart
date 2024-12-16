import 'package:material/material.dart';

class CustomTextInput extends StatefulWidget {
    final String hint;
    final String? title;
    final ValueChanged<String>? onChanged;
    final VoidCallback? onEditingComplete;
    final ValueChanged<String>? onSubmitted;
    final Widget? icon;
    final String error;
    final String? presetTxt;
    final TextEditingController? controller;
    final int? maxLines;

    const CustomTextInput({
        super.key,
        this.title,
        this.hint = 'Enter the text here',
        this.onChanged,
        this.onEditingComplete,
        this.onSubmitted,
        this.icon,
        this.error = '',
        this.presetTxt,
        this.controller,
        this.maxLines = 10,
    });

    @override
    CustomTextInputState createState() => CustomTextInputState();
}

class CustomTextInputState extends State<CustomTextInput> {
    late TextEditingController controller;
    var borderColor = Display.outline_secondary;
    var textColor = Display.text_heading;
    var isFocused = false;
    var focusNode = FocusNode();

    @override
    void initState() {
        controller = widget.controller ?? TextEditingController(text: widget.presetTxt);
        focusNode.addListener(_onFocusChange);
        super.initState();
    }

    @override
    void dispose() {
        focusNode.dispose();
        if (widget.controller == null) {
            controller.dispose();
        }
        super.dispose();
    }

    void _onFocusChange() {
        setState(() {
            isFocused = focusNode.hasFocus;
            borderColor = isFocused ? Display.outline_secondary : Display.outline_primary;
            textColor = Display.text_primary;
            if (!isFocused && controller.text.isEmpty) {
                borderColor = Display.outline_secondary;
            }
        });
    }

    @override
    Widget build(BuildContext context) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                widget.title != null
                    ? Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: CustomText(variant: 'heading', font_size: 'h5', txt: widget.title!),
                    )
                    : Container(),
                Container(
                    width: double.infinity,
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1,
                                color: borderColor,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                                Expanded(
                                    child: TextField(
                                        minLines: 1,
                                        maxLines: widget.maxLines,
                                        controller: controller,
                                        focusNode: focusNode,
                                        cursorWidth: 2.0,
                                        cursorColor: Display.text_secondary,
                                        style: TextStyle(color: textColor),
                                        onChanged: (String text) => widget.onChanged,
                                        onSubmitted: widget.onSubmitted,
                                        onEditingComplete: widget.onEditingComplete,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                            hintText: widget.hint,
                                            hintStyle: const TextStyle(color: Display.outline_primary),
                                            border: InputBorder.none,
                                            filled: true,
                                            fillColor: Display.bg_primary,
                                        ),
                                    ),
                                ),
                                widget.icon ?? Container(),
                            ],
                        ),
                    ),
                ),
                widget.error == '' ? Container () : Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: CustomText(variant:'text', font_size: 'sm', text_color: Display.status_danger, txt: widget.error),
                )
            ],
        );
    }
}
