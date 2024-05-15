import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';

import 'package:qr_flutter/qr_flutter.dart';

class Receive extends StatefulWidget {
  const Receive({super.key});

  @override
  ReceiveState createState() => ReceiveState();
}

final address = ValueNotifier<String>("...");
String shortenedAddress = '';
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
      shortenedAddress = shortenAddress(address.value);
      isLoading = false;
    });
  }

  String shortenAddress(address) {
    if (address.length > 30) {
      final firstPart = address.substring(0, 15);
      final lastPart = address.substring(address.length - 15);
      return '$firstPart...$lastPart';
    }
    return address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive'),
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
                      width: 250,
                      height: 250,
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
                          padding: const EdgeInsets.all(20.0),
                          child: ValueListenableBuilder<String>(
                            valueListenable: address,
                            builder:
                                (BuildContext context, String value, child) {
                              return QrImageView(
                                  data: value,
                                  version: QrVersions.auto,
                                  backgroundColor: Colors.white);
                            },
                          )),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your Address:',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            shortenedAddress,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: address.value));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Address copied to clipboard')),
                            );
                          },
                          icon: const Icon(Icons.content_copy,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await getNewAddress();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Generate New Address',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
    );
  }
}
