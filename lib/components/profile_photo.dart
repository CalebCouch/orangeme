import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';


Widget profilePhotoStack(BuildContext context, List<DartProfile> contacts) {
    return Container(
        width: 128,
        height: 32,
        alignment: Alignment.center,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: contacts.length < 5 ? contacts.length : 5,
            itemBuilder: (BuildContext context, int index) {
                return Align(
                    widthFactor: 0.75,
                    child: ProfilePhoto(context, contacts[index].pfpPath, ProfileSize.md, true),
                );
            },
        ),
    );
}
