import 'package:flutter/material.dart';
// import 'package:orange/flows/bitcoin/send/confirm.dart';
// import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/global.dart' as global;
import 'package:orange/classes.dart';


class Speed extends GenericWidget {
    String address;
    BigInt amount; 
    Speed(this.address, this.amount, {super.key});

    String standard = "";
    String priority = "";

    @override
    SpeedState createState() => SpeedState();
}

class SpeedState extends GenericState<Speed> {
    @override
    PageName getPageName() {
        return PageName.speed(widget.amount);
    }

    @override
    int refreshInterval() {
        return 0;
    }

    @override
    void unpack_state(Map<String, dynamic> json) {
        setState(() {
            widget.standard = json["standard_fee"] as String;
            widget.priority = json["priority_fee"] as String;
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
        //navigateTo(context, const Confirm());
    }


    @override
    Widget build_with_state(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Transaction speed"),
            content: [SpeedSelector(widget.fees)],
            bumper: Bumper(context, content: [
                CustomButton( txt: 'Continue', onTap: onContinue)
            ]),
            alignment: Alignment.topCenter,
            isLoading: isLoading,
        );
    }

    //The following widgets can ONLY be used in this file

    Widget SpeedSelector(fees) {
        return CustomColumn([
            RadioButton(
                title: "Standard",
                subtitle: "Arrives in ~2 hours\n${widget.standard} bitcoin network fee",
                isEnabled: index == 0,
                onTap: () {
                    setState(() {
                        index = 0;
                    });
                },
            ),
            RadioButton(
                title: "Priority",
                subtitle: "Arrives in ~30 minutes\n${widget.priority} bitcoin network fee",
                isEnabled: index == 1,
                onTap: () {
                    setState(() {
                        index = 1;
                    });
                },
            )
        ]);
    }
}

Widget RadioButton({required String title, required String subtitle, required bool isEnabled, required onTap}) {
    return InkWell(
        onTap: onTap,
        child: Container(
            color: Colors.transparent,
            width: double.infinity,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    CustomIcon(
                        icon: isEnabled ? 'radioFilled' : 'radio', 
                        size: 'lg', 
                        key: UniqueKey()
                    ),
                    const Spacing(16),
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: CustomColumn([
                            CustomText(
                                variant: 'heading', 
                                font_size: 'h5', 
                                txt: title, 
                                alignment: TextAlign.left
                            ),
                            CustomText(
                                variant: 'text',
                                font_size: 'sm',
                                text_color: 'text_secondary', 
                                txt: subtitle, 
                                alignment: TextAlign.left
                            ),
                        ], 8, true, false),
                    ),
                ],
            ),
        ),
    );
}
