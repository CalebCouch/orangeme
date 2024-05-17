import 'package:flutter/material.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'package:orange/styles/constants.dart';
import 'package:share/share.dart';

class Receive extends StatefulWidget {
  const Receive({super.key});

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

  void onPageLoad() async {
    await getNewAddress();
  }

  Future<void> getNewAddress() async {
    var descriptors =
        HandleNull(await STORAGE.read(key: "descriptors"), context);
    address.value = HandleError(
        await invoke(
            method: "get_new_address", args: [await GetDBPath(), descriptors]),
        context);

    setState(() {
      isLoading = false;
    });
  }

  void onShare() {
    final String textToShare = address.value;
    Share.share(textToShare);
  }

  // String shortenAddress(address) {
  //   if (address.length > 30) {
  //     final firstPart = address.substring(0, 15);
  //     final lastPart = address.substring(address.length - 15);
  //     return '$firstPart...$lastPart';
  //   }
  //   return address;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive Bitcoin'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 312,
                      height: 312,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.8),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ValueListenableBuilder<String>(
                            valueListenable: address,
                            builder:
                                (BuildContext context, String value, child) {
                              return QrImageView(
                                  data: value,
                                  version: QrVersions.auto,
                                  size: 200.0,
                                  gapless: false,
                                  embeddedImage: const AssetImage(
                                      'assets/icons/qrcode_brandmark.png'),
                                  embeddedImageStyle:
                                      const QrEmbeddedImageStyle(
                                          size: Size(68, 68)),
                                  backgroundColor: Colors.white);
                            },
                          )),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Scan to receive Bitcoin.',
                      style: AppTextStyles.textMD
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 150),
                    Expanded(
                      child: ButtonOrangeLG(
                        label: "Share",
                        onTap: () => onShare(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
