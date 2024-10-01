import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'dart:io' show Platform;
import 'package:orange/components/tab_navigator.dart';
import 'package:orange/components/sidebar.dart';
import 'package:orange/classes.dart';

// This file defines a responsive Interface layout that adapts between mobile and
// desktop views, using MobileInterface for mobile devices with optional navigation
// and bumper, and DesktopInterface for desktops with a sidebar and padding.

/* A responsive layout that switches between mobile and desktop views based on the platform. */
class Interface extends StatelessWidget {
  final bool? resizeToAvoidBottomInset;
  final Widget header;
  final Widget content;
  final Widget? bumper;
  final GlobalState globalState;
  final int navigationIndex;
  final bool desktopOnly;

  const Interface(
    this.globalState, {
    super.key,
    this.resizeToAvoidBottomInset,
    required this.header,
    required this.content,
    this.bumper,
    required this.navigationIndex,
    this.desktopOnly = false,
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
        navBar: !desktopOnly
            ? TabNav(globalState, index: navigationIndex)
            : Container(),
      );
    }
    return DesktopInterface(
        header: header,
        content: SizedBox(
          child: content,
        ),
        bumper: bumper,
        sidebar: Sidebar(globalState, index: navigationIndex));
  }
}

/* A mobile layout with optional bottom navigation bar and bumper. */
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
      body: Container(
        // color: Colors.blueGrey,
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

/* A desktop layout featuring a sidebar and padding, with optional bumper. */
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
            child: Container(
              padding: const EdgeInsets.all(AppPadding.desktop),
              child: Column(
                children: [
                  header,
                  Expanded(child: content),
                  if (bumper != null) bumper!,
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
