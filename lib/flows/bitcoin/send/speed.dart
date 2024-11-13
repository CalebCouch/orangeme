import 'package:flutter/material.dart';
// import 'package:orange/flows/bitcoin/send/confirm.dart';
// import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/global.dart' as global;
import 'package:orange/classes.dart';


class Speed extends GenericWidget {
    String address;
    double amount;
    Speed(this.address, this.amount, {super.key});

    dynamic fees = (0.0, 0.0);

    @override
    SpeedState createState() => SpeedState();
}

class SpeedState extends GenericState<Speed> {
    @override
    PageName getPageName() {
        return PageName.speed(widget.address, widget.amount);
    }

    @override
    int refreshInterval() {
        return 0;
    }

    @override
    void unpack_state(Map<String, dynamic> json) {
        print("Unpacking");
        setState(() {
            widget.fees = (json["fees"] as List<dynamic>).map((e) => e as double).toList();
        });
    }

    int index = 0;
    bool isLoading = false;

    @override
    void initState() {
        setState(() {
            isLoading = false;
        });
        super.initState();
    }

    onContinue() {
        //navigateTo(context, const Confirm()); //create transaction with all the data (index as priority speed)
    }


    @override
    Widget build_with_state(BuildContext context) {
        return Stack_Default(
            Header_Stack(context, "Transaction speed"),
            [SpeedSelector(widget.fees)],
            Bumper(context, [CustomButton('Continue', 'primary lg expand none', onContinue, 'enabled')]),
            Alignment.topCenter,
            true,
            isLoading,
        );
    }

    //The following widgets can ONLY be used in this file

    Widget SpeedSelector(fees) {
        return CustomColumn([
        radioButton(
            "Standard",
            "Arrives in ~2 hours\n${fees[0]} bitcoin network fee",
            index == 0,
            () {
            setState(() {
                index = 0;
            });
            },
        ),
        radioButton(
            "Priority",
            "Arrives in ~30 minutes\n${fees[1]} bitcoin network fee",
            index == 1,
            () {
            setState(() {
                index = 1;
            });
            },
        )
        ]);
    }
}

Widget radioButton(String title, String subtitle, bool isEnabled, onTap) {
    String icon = isEnabled ? 'radioFilled' : 'radio';
    return InkWell(
        onTap: onTap,
        child: Container(
        color: Colors.transparent,
        width: double.infinity,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            CustomIcon('$icon lg', key: UniqueKey()),
            const Spacing(16),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: CustomColumn([
                CustomText('heading h5', title, alignment: TextAlign.left),
                CustomText('text sm text_secondary', subtitle, alignment: TextAlign.left),
                ], 8, true, false),
            ),
            ],
        ),
        ),
    );
}
