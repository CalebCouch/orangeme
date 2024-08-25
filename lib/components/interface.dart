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
  final GlobalState globalState;
  final Widget? header;
  final Widget content;
  final Widget? paginator;
  final Widget? bumper;
  final int? navigationIndex;
  final bool? resizeToAvoidBottomInset;
  final bool desktopOnly;

  const Interface(
    this.globalState, {
    super.key,
    required this.content,
    this.header,
    this.paginator,
    this.bumper,
    this.navigationIndex,
    this.resizeToAvoidBottomInset,
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
        paginator: paginator,
        bumper: bumper,
        navBar: !desktopOnly
            ? navigationIndex != null
                ? TabNav(globalState, index: navigationIndex!)
                : Container()
            : Container(),
      );
    }
    return DesktopInterface(
      header: header,
      content: SizedBox(
        child: content,
      ),
      paginator: paginator,
      bumper: bumper,
      sidebar: navigationIndex != null
          ? Sidebar(globalState, index: navigationIndex!)
          : Container(),
    );
  }
}

/* A mobile layout with optional bottom navigation bar and bumper. */
class MobileInterface extends StatelessWidget {
  final bool? resizeToAvoidBottomInset;
  final Widget? header;
  final Widget content;
  final Widget? paginator;
  final Widget? bumper;
  final Widget? navBar;

  const MobileInterface({
    super.key,
    this.resizeToAvoidBottomInset,
    this.header,
    required this.content,
    this.paginator,
    this.bumper,
    this.navBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SafeArea(
        child: Column(
          children: [
            if (header != null) header!,
            Expanded(child: content),
            if (paginator != null) paginator!,
            if (bumper != null) bumper!,
            if (navBar != null) navBar!,
          ],
        ),
      ),
    );
  }
}

/* A desktop layout featuring a sidebar and padding, with optional bumper. */
class DesktopInterface extends StatelessWidget {
  final Widget? header;
  final Widget content;
  final Widget? paginator;
  final Widget? bumper;
  final Widget? sidebar;

  const DesktopInterface({
    super.key,
    this.header,
    required this.content,
    this.paginator,
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
                  if (header != null) header!,
                  Expanded(child: content),
                  if (paginator != null) paginator!,
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
