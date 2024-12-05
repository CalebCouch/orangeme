import 'package:flutter/material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/text.dart';

// INTERFACE PARTS //

Widget Bumper( BuildContext context, {
    required List<Widget> content,
    bool vertical = false,
}) {
    return Container(
        constraints: const BoxConstraints(maxWidth: 422),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: vertical ? CustomColumn(content, 16) : CustomRow(content, 16),
    );
}


class Content extends StatelessWidget {
    final List<Widget> children;
    final Alignment alignment;
    const Content(
        this.children, {
        super.key,
        this.alignment = Alignment.topCenter,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            constraints: const BoxConstraints(maxWidth: 422),
            padding: const EdgeInsets.all(24),
            child: Container(
                alignment: alignment,
                child: CustomColumn(children, 24, (alignment == Alignment.center)),
            ),
        );
    }
}

Widget Interface(bool scroll, Widget child) {
    return PopScope(
        canPop: false,
        child: Scaffold(
            resizeToAvoidBottomInset: scroll,
            body: SafeArea(
                child: child,
            ),
        ),
    );
}


// INTERFACES //

Widget Root_Home({
  required Widget header,
  required List<Widget> content,
  required Widget bumper,
  required Widget tabNav,
  Alignment alignment = Alignment.topCenter,
  bool scroll = true,
}) {
    return Interface(
        scroll,
        Column(
            children: [
                header,
                !scroll ? Expanded( 
                    child: Content(
                        content, 
                        alignment: alignment
                        )
                ) : Expanded(
                    child: SingleChildScrollView(
                        child: Content(content),
                    ),
                ),
                bumper,
                tabNav,
            ],
        ),
    );
}


Widget Root_Takeover({ required Widget header, required Widget content}) {
    return Interface(
        false,
        Column(
            children: [
                header,
                Expanded( 
                    child: content,
                )
            ],
        ),
    );
}

Widget Stack_Default({
  required Widget header,
  required List<Widget> content,
  required Widget bumper,
  Alignment alignment = Alignment.topCenter,
  bool scroll = true,
}) {
    return Interface(
        scroll,
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                header,
                !scroll ? Expanded(
                    child: Content(
                        content, 
                        alignment: alignment
                    )
                ) : Expanded(
                    child: SingleChildScrollView(
                        child: Content(content),
                    ),
                ),
                bumper,
            ],
        ),
    );
}


Widget Stack_Scroll({
    required Widget header,
    required List<Widget> content,
}) {
    return Interface(
        false,
        SingleChildScrollView(
            child: Column(
                children: [
                    header,
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: CustomColumn(content, 24),
                    ),
                ],
            ),
        ),
    );
}


Widget Stack_Chat({
    required Widget header,
    required List<dynamic> content,
    required Widget bumper,
}) {
    return Interface(
        false,
        Column(
            children: [
                header,
                if (content[0]) Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(24),
                        child: content[1],
                    ),
                ) else const Expanded(
                    child: Center(
                        child: CustomText(
                            variant: 'text',
                            font_size: 'md',
                            text_color: 'text_secondary',
                            txt: 'No messages yet.',
                        ),
                    ),
                ),
                bumper,
            ],
        ),
    );
}

// CUSTOM INTERFACE WIDGETS //

Widget CustomColumn(List<Widget> children, [double spacing = 24, bool centerH = true, bool centerV = true]) {
  List<Widget> content = [];

    for (int i = 0; i < children.length; i++) {
        if(children[i] is! SizedBox) {
            content.add(children[i]);
            if (i < children.length - 1) {
                content.add(Container(child:Spacing(spacing)));
            }
        } else {
            SizedBox sizedBox = children[i] as SizedBox;
            if (sizedBox.child != null) {
                content.add(children[i]);
            }
        }
    }
    return Container(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: centerH ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: centerV ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: content,
    ),);
}

Widget CustomRow(List<Widget> children, [double spacing = 8]) {
    List<Widget> content = [];

    for (int i = 0; i < children.length; i++) {
        content.add(children[i]);
        if (i < children.length - 1) {
            content.add(Spacing(spacing));
        }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: content);
}

class Spacing extends StatelessWidget {
    final double? size;

    const Spacing(this.size, {super.key,});

    @override
    Widget build(BuildContext context) {
        return SizedBox(width: size, height: size);
    }
}