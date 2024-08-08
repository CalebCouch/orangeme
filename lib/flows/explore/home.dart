import 'package:flutter/material.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/components/tip_buttons.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/tab_navigator.dart';

import 'package:orange/classes/test_classes.dart';
import 'package:orange/flows/messages/conversation/room.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class ExploreHome extends StatefulWidget {
  final GlobalState globalState;
  final List<Info> promotedRooms;
  const ExploreHome(
    this.globalState,
    this.promotedRooms, {
    super.key,
  });

  @override
  ExploreHomeState createState() => ExploreHomeState();
}

class ExploreHomeState extends State<ExploreHome> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  Widget build_screen(BuildContext context, DartState state) {
    return DefaultInterface(
      header: primaryHeader(context, null, 'Explore'),
      content: Content(
        content: SizedBox(
          height: double.infinity,
          child: ListView.builder(
            itemCount: widget.promotedRooms.length,
            itemBuilder: (BuildContext context, int index) {
              return advertisement(
                widget.globalState,
                context,
                widget.promotedRooms[index],
              );
            },
          ),
        ),
      ),
      navBar: TabNav(globalState: widget.globalState, index: 2),
    );
  }
}

Widget advertisement(GlobalState globalState, BuildContext context, Info info) {
  String roomName = getName(info, true);
  return InkWell(
    onTap: () {
      navigateTo(
          context,
          Room(globalState,
              conversation: Conversation(info.members, [], info)));
    },
    child: Container(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: ThemeColor.outline),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          children: [
            ProfilePhoto(
              size: ProfileSize.xxl,
              profilePhoto: info.photo ?? info.creator.pfp,
            ),
            const Spacing(height: 6),
            CustomText(
                text: roomName, textType: 'heading', textSize: TextSize.h3),
            const Spacing(height: 6),
            CustomText(
              text: "${info.members.length.toString()} Members",
              textSize: TextSize.xs,
            ),
            const Spacing(height: 12),
            Container(
              color: ThemeColor.outline,
              height: 1,
              width: double.infinity,
            ),
            const Spacing(height: 12),
            CustomText(
              text: info.desc ??
                  "A room for all of ${info.creator.name}'s friends",
              textSize: TextSize.sm,
            ),
            const Spacing(height: 14),
            ButtonTip(
              'Join Room',
              ThemeIcon.door,
              () {},
            ),
            const Spacing(height: 8),
          ],
        ),
      ),
    ),
  );
}
