import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:orange/components/tab_navigator.dart';
import 'package:orange/components/sidebar.dart';
import 'package:orange/classes.dart';

class Interface extends StatelessWidget {
  final bool? resizeToAvoidBottomInset;
  final Widget header;
  final Widget content;
  final Widget? bumper;
  final GlobalState? globalState;
  final int? navigationIndex;

  const Interface({
    super.key,
    this.globalState,
    this.resizeToAvoidBottomInset,
    required this.header,
    required this.content,
    this.bumper,
    this.navigationIndex,
  });
  @override
  Widget build(BuildContext context) {
    print("platform $Platform");
    if (Platform.isAndroid || Platform.isIOS) {
      return MobileInterface(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        header: header,
        content: content,
        bumper: bumper,
        navBar: navigationIndex != null && globalState != null
            ? TabNav(globalState!, index: navigationIndex!)
            : Container(),
      );
    }
    return DesktopInterface(
      header: header,
      content: SizedBox(
        child: content,
      ),
      bumper: bumper,
      sidebar: navigationIndex != null && globalState != null
          ? Sidebar(globalState!, index: navigationIndex!)
          : Container(),
    );
  }
}

class MobileInterface extends StatelessWidget {
  final bool? resizeToAvoidBottomInset;
  final Widget header;
  final Widget content;
  final Widget? bumper;
  final Widget? navBar;

  const MobileInterface({
    super.key,
    this.resizeToAvoidBottomInset,
    required this.header,
    required this.content,
    this.bumper,
    this.navBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: SafeArea(
          child: Column(
            children: [
              header,
              Expanded(child: content),
              if (bumper != null) bumper!,
              if (navBar != null) navBar!,
            ],
          ),
        ),
      ),
    );
  }
}

class DesktopInterface extends StatelessWidget {
  final Widget header;
  final Widget content;
  final Widget? bumper;
  final Widget? sidebar;

  const DesktopInterface({
    super.key,
    required this.header,
    required this.content,
    this.bumper,
    this.sidebar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Row(
        children: [
          if (sidebar != null) sidebar!,
          Expanded(
            child: Column(
              children: [
                header,
                Expanded(child: content),
                if (bumper != null) bumper!,
              ],
            ),
          ),
        ],
      )),
    );
  }
}
