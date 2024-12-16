import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material/material.dart';
import 'package:flow_bitcoin/flow_bitcoin.dart';
import 'package:orange/global.dart' as global;

class ErrorPage extends StatefulWidget {
  final String message;

  const ErrorPage({super.key, required this.message});

  @override
  ErrorPageState createState() => ErrorPageState();
}

class ErrorPageState extends State<ErrorPage> {
    bool showError = false;
    @override
    Widget build(BuildContext context) {
        onTap() {
            if (showError) {
                setState(() => showError = false);
            } else {
                setState(() => showError = true);
            }
        }

        tryAgain() {
            global.startRust();
            global.navigation.navigateTo(BitcoinHome());
        }

        return Stack_Default(
            header: Container(),
            content: [
                const Spacing(24),
                Container(
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Display.bg_secondary,
                    ),
                    child: SvgPicture.asset('assets/images/dodo.svg'),
                ),
                const CustomText(
                    variant: 'heading',
                    font_size: 'h3',
                    text_color: Display.text_heading,
                    txt: 'Uh-oh!\nSomething went wrong.'
                ),
                Container(height: 1, width: 400, color:  Display.bg_secondary),
                CustomButton(
                    txt: showError ? 'Hide Error' : 'Show Error', 
                    variant: 'secondary',
                    size: 'md',
                    expand: false, 
                    icon: 'error', 
                    onTap: onTap,
                ),
                showError ? error(widget.message) : Container(),
                const Spacing(12),
            ],
            bumper: Bumper(context, content: [
                CustomButton(
                    txt: 'Try Again',
                    variant: 'secondary',
                    size: 'lg',
                    onTap: tryAgain,
                )
            ]),
        );
    }
}

Widget error(message) {
    return Container(
        decoration: BoxDecoration(
            color:  Display.bg_secondary,
            border: Border.all(color:  Display.outline_secondary),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        padding: const EdgeInsets.all(12),
        child: CustomText(
            variant: 'text',
            font_size: 'lg',
            text_color: Display.text_heading, 
            txt: message
        ),
    );
}
