import 'package:flow_bitcoin/flow_bitcoin.dart';

import 'package:material/navigation.dart';
import 'package:material/material.dart';

class Success extends GenericWidget {
    String rawTx;
    String amount_usd;

    Success(this.rawTx, this.amount_usd, {super.key});

    @override
    SuccessState createState() => SuccessState();
}

class SuccessState extends GenericState<Success> {

    @override
    PageName getPageName() {
        return PageName.success(widget.rawTx);
    }

    @override
    int refreshInterval() {
        return 0;
    }

    @override
    void unpack_state(Map<String, dynamic> json) {}

    Widget build_with_state(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Send confirmed", Container(), ExitButton(context, BitcoinHome())),
            content: [Result()],
            bumper: Bumper(context, content: [
                CustomButton(
                    txt: 'Done', 
                    variant: 'secondary', 
                    onTap: () {resetNavTo(context, BitcoinHome());},
                ),
            ]),
            alignment: Alignment.center,
            scroll: false,
        );
    }

    Widget Result() {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                CustomIcon(icon: 'bitcoin', size: 'xxl'),
                const Spacing(16),
                CustomText(variant:'heading', font_size: 'h3', txt: 'You sent ${widget.amount_usd}'),
            ],
        );
    }
}
