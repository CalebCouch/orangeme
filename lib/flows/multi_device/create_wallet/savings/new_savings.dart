import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/flows/multi_device/create_wallet/savings/download_desktop.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:orange/components/radio.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/components/qr_code/qr_code.dart';

class NewSavings extends StatefulWidget {
  NewSavings({super.key});

  @override
  NewSavingsState createState() => NewSavingsState();
}

class NewSavingsState extends State<NewSavings> {
    final LoopPageController _controller = LoopPageController();
    int _currentIndex = 0;

    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "New savings wallet"),
            content: [
                Expanded(
                    child: LoopPageView.builder(
                        controller: _controller,
                        onPageChanged: (page) {
                            setState(() => _currentIndex = page);
                        },
                        itemCount: 4,
                        itemBuilder: (_, index) {
                            final pageContent = getPageContent(index);
                            return CustomColumn([
                                Expanded ( child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxHeight: 450),
                                    child: Image.asset(pageContent.imagePath),
                                )),
                                CustomText(variant: 'heading', font_size: 'h3', txt: pageContent.description),
                            ]);
                        },
                    ),
                ),
                buildPaginator(_currentIndex, 4),
            ],
            bumper: Bumper( context, content: [CustomButton(txt: 'Continue', onTap: () {navigateTo(context, DownloadDesktop());})]),
            alignment: Alignment.center,
            scroll: false,
        );
    }

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }
}

class PageContent {
    final String imagePath;
    final String description;

    PageContent(this.imagePath, this.description);
}

PageContent getPageContent(int index) {
    switch (index) {
        case 3:
            return PageContent(
                'assets/mockups/USBCMockup.png',
                'Setting up a savings wallet will create 1-3 USB security keys',
            );
        case 1:
            return PageContent(
                'assets/mockups/PaginatorFriends.png',
                'Setting up a savings wallet will back up your friends list and accounts',
            );
        case 2:
            return PageContent(
                'assets/mockups/WalletDesktop.png',
                'After setting up a savings wallet you can upgrade the security of your bitcoin spending wallets',
            );
        default:
            return PageContent(
                'assets/mockups/WalletDesktop.png',
                'Savings is a bitcoin wallet that stays protected even if your phone gets hacked',
            );
    }
}

Widget buildPaginator(int currentIndex, int totalPages) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (index) {
                return Row(children: [
                    buildCircle(currentIndex, index),
                    if (index < totalPages - 1) const SizedBox(width: 8),
                ]);
            }),
        ),
    );
}

Widget buildCircle(int currentIndex, int pageIndex) {
    return Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
            color: currentIndex == pageIndex ? ThemeColor.border : ThemeColor.bgSecondary,
            shape: BoxShape.circle,
        ),
    );
}
