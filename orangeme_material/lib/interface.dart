import 'package:flutter/material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/text.dart';

Widget Bumper(BuildContext context, List<Widget> children, [bool vertical = false]) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.center,
    child: vertical ? CustomColumn(children, 16) : CustomRow(children, 16),
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
      constraints: const BoxConstraints(maxWidth: 396),
      padding: const EdgeInsets.all(24),
      child: Container(
        alignment: alignment,
        child: CustomColumn(children, 24, (alignment == Alignment.center)),
      ),
    );
  }
}

Widget CustomColumn(List<Widget> children, [double spacing = 24, bool centerH = true, bool centerV = true]) {
  List<Widget> content = [];

  for (int i = 0; i < children.length; i++) {
    content.add(children[i]);
    if (i < children.length - 1) {
      content.add(Spacing(spacing));
    }
  }
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: centerH ? MainAxisAlignment.center : MainAxisAlignment.start,
    crossAxisAlignment: centerV ? CrossAxisAlignment.center : CrossAxisAlignment.start,
    children: content,
  );
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

  const Spacing(
    this.size, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
    );
  }
}

// INTERFACES //

Widget Root_Home(Widget header, List<Widget> content, Widget bumper, Widget TabNav, [Alignment alignment = Alignment.topCenter, bool scroll = true]) {
  return PopScope(
    canPop: false,
    child: Scaffold(
      resizeToAvoidBottomInset: scroll,
      body: SafeArea(
        child: Column(
          children: [
            header,
            !scroll ? Expanded(child: Content(content, alignment: alignment)) : Expanded(child: SingleChildScrollView(child: Content(content))),
            bumper,
            TabNav,
          ],
        ),
      ),
    ),
  );
}

Widget Root_Takeover(Widget header, Widget content) {
  return PopScope(
    canPop: false,
    child: Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            header,
            content,
          ],
        ),
      ),
    ),
  );
}

Widget Stack_Default(Widget header, List<Widget> content, Widget bumper,
    [Alignment alignment = Alignment.topCenter, bool scroll = true, bool isLoading = false]) {
  return PopScope(
    canPop: false,
    child: Scaffold(
      resizeToAvoidBottomInset: scroll,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: isLoading ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: isLoading
              ? [loadingCircle()]
              : [
                  header,
                  !scroll ? Expanded(child: Content(content, alignment: alignment)) : Expanded(child: SingleChildScrollView(child: Content(content))),
                  bumper,
                ],
        ),
      ),
    ),
  );
}

Widget Stack_Scroll(Widget header, List<Widget> content) {
  return PopScope(
    canPop: false,
    child: Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              header,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomColumn(content, 24),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget Stack_Chat(Widget header, List<dynamic> exchangeData, Widget bumper) {
  return PopScope(
    canPop: false,
    child: Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            header,
            if (exchangeData[0])
              Expanded(child: Container(padding: const EdgeInsets.all(24), child: exchangeData[1]))
            else
              const Expanded(child: Center(child: CustomText('text md text_secondary', 'No messages yet.'))), //[bool, messages]
            bumper,
          ],
        ),
      ),
    ),
  );
}
