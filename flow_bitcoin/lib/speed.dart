import 'package:flow_bitcoin/flow_bitcoin.dart';
// import 'package:material/navigation.dart';
import 'package:material/material.dart';

import 'package:tuple/tuple.dart';

class Speed extends GenericWidget {
    String address;
    BigInt amount;
    Speed(this.address, this.amount, {super.key});

    String priority_f = "";
    BigInt priority = BigInt.from(0);
    String standard_f = "";
    BigInt standard = BigInt.from(0);

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
        widget.priority_f = json["priority_f"] as String;
        widget.priority = BigInt.from(json["priority"]);
        widget.standard_f = json["standard_f"] as String;
        widget.standard = BigInt.from(json["standard"]);
    }

    int index = 0;

    @override
    void initState() {
        super.initState();
    }

    onContinue() {
        navigateTo(Confirm(widget.address, widget.amount, index == 0 ? widget.standard : widget.priority));
    }


    @override
    Widget build_with_state(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Transaction speed"),
            content: [SpeedSelector()],
            bumper: Bumper(context, content: [
                CustomButton( txt: 'Continue', onTap: onContinue)
            ]),
            alignment: Alignment.topCenter,
        );
    }

    //The following widgets can ONLY be used in this file

    Widget SpeedSelector(){
        return ListSelector(
            one: Tuple2("Standard", "Arrives in ~2 hours\n${widget.standard_f} bitcoin network fee"), 
            two: Tuple2("Priority", "Arrives in ~30 minutes\n${widget.priority_f} bitcoin network fee"),
            currentIndex: index,
            onIndexChanged: (newIndex) {
                setState(() {
                    index = newIndex;
                });
            },
        );
    }
}
