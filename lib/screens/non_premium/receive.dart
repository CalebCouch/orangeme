import 'package:flutter/material.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import '../../components/custom_qr_generator/custom_qr_generator.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'package:orange/styles/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';

class Receive extends StatefulWidget {
  final VoidCallback onDashboardPopBack;

  const Receive({super.key, required this.onDashboardPopBack});

  @override
  ReceiveState createState() => ReceiveState();
}

final address = ValueNotifier<String>("...");
bool isLoading = true;

class ReceiveState extends State<Receive> {
  @override
  void initState() {
    onPageLoad();
    super.initState();
  }

  //page initialization
  void onPageLoad() async {
    await getNewAddress();
  }

  //generate a fresh Bitcoin address
  Future<void> getNewAddress() async {
    var descriptorsRes = await STORAGE.read(key: "descriptors");
    if (!mounted) return;
    var descriptors = handleNull(descriptorsRes, context);
    var addressRes = await invoke(
        method: "get_new_address", args: [await getDBPath(), descriptors]);
    if (!mounted) return;
    address.value = handleError(addressRes, context);

    setState(() {
      isLoading = false;
    });
  }

  //used to bring up the OS native share window
  void onShare() {
    final String textToShare = address.value;
    Share.share(textToShare);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child:
                  const Text('Receive Bitcoin', style: AppTextStyles.heading4),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: SvgPicture.asset(
                  AppIcons.left,
                  width: 32,
                  height: 32,
                ),
                onPressed: () {
                  widget.onDashboardPopBack();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ValueListenableBuilder<String>(
                              valueListenable: address,
                              builder:
                                  (BuildContext context, String value, child) {
                                return CustomPaint(
                                  size: const Size(312, 312),
                                  painter: QrPainter(
                                    data: value,
                                    options: const QrOptions(
                                      shapes: QrShapes(
                                        darkPixel: QrPixelShapeCircle(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          child: SvgPicture.asset(
                            AppIcons.brandmarkLG,
                            width: 74,
                            height: 74,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Scan to receive bitcoin.',
                        style: AppTextStyles.textMD
                            .copyWith(color: AppColors.textSecondary)),
                  ]),
            ),
      bottomNavigationBar: Container(
        padding:
            const EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 32),
        child: ButtonOrangeLG(
          label: "Share",
          onTap: () => onShare(),
        ),
      ),
    );
  }
}
