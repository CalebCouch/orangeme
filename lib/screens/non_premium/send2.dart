import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'send3.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/components/textfield.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'package:orange/components/buttons/secondary_md.dart';
import 'package:orange/styles/constants.dart';

class Send2 extends StatefulWidget {
  final double amount;
  const Send2({
    super.key,
    required this.amount,
  });

  @override
  Send2State createState() => Send2State();
}

class Send2State extends State<Send2> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController? controller;
  final TextEditingController recipientAddressController =
      TextEditingController();
  bool isAddressValid = false;
  bool isButtonEnabled = false;
  String clipboardData = '';
  Timer? clipboardCheckTimer;

  @override
  void initState() {
    super.initState();
    fetchAndValidateClipboard();
    // recipientAddressController
    //     .addListener(trimAddressPrefix(recipientAddressController.text));
    recipientAddressController.addListener(buttonListner);
    // fetchAndValidateClipboard();
    clipboardCheckTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        fetchAndValidateClipboard();
      }
    });
  }

  Future<void> fetchAndValidateClipboard() async {
    if (!mounted) return;
    print("Checking Clipboard Data");
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      String trimmedData = trimAddressPrefix(clipboardData!.text);
      bool isValid = await checkAddress(trimmedData);
      if (isValid) {
        setState(() {
          this.clipboardData = clipboardData.text!;
        });
      } else {
        setState(() {
          this.clipboardData = "";
        });
      }
    }
  }

  void _startQRScanner() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          content: SizedBox(
            width: 300,
            height: 300,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _stopQRScanner();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController newController) {
    controller = newController;
    controller!.scannedDataStream.listen((scanData) async {
      print('Scanned Data: ${scanData.code}');
      String trimmed = trimAddressPrefix(scanData.code);
      var validAddress = await checkAddress(trimmed);
      if (validAddress) {
        recipientAddressController.text = trimmed;
      }
      await controller!.stopCamera(); // Stop the camera
      closeDialog(); // Close the QR code scanner dialog
    });
  }

  void closeDialog() {
    Navigator.of(context).pop();
    if (controller != null && mounted) {
      controller!.dispose();
    }
  }

  pasteAddress() {
    recipientAddressController.text = clipboardData;
  }

  String trimAddressPrefix(String? contents) {
    if (contents!.startsWith('bitcoin:')) {
      //remove the bitcoin: prefix if applicable
      String updatedText = contents.substring(8);
      return updatedText;
    } else {
      return contents;
    }
  }

  Future<bool> checkAddress(String address) async {
    print("address check:");
    var res = HandleError(
        await invoke(method: "check_address", args: [address]), context);
    return res == "true";
  }

  void buttonListner() async {
    if (await checkAddress(recipientAddressController.text) == true) {
      setState(() {
        isButtonEnabled = true;
      });
    } else {
      setState(() {
        isButtonEnabled = false;
      });
    }
  }

  void onContinue() {
    _stopTimer();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Send3(
                amount: widget.amount,
                address: recipientAddressController.text)));
  }

  String truncateAddress(address) {
    if (address.length > 30) {
      final firstPart = address.substring(0, 15);
      return '$firstPart...';
    }
    return address;
  }

  void _stopQRScanner() {
    if (controller != null) {
      Navigator.pop(context);
      controller!.dispose();
    }
  }

  void _stopTimer() {
    print("stop timer...");
    clipboardCheckTimer?.cancel();
  }

  @override
  void dispose() {
    recipientAddressController.dispose();
    clipboardCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Amount to send: ${widget.amount}");
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) async {
        _stopTimer();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Bitcoin Address'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextInputField(
                  controller: recipientAddressController,
                  hint: "Bitcoin address...",
                ),
                const SizedBox(height: 10),
                if (clipboardData != '') ...[
                  ButtonSecondaryMD(
                    label: truncateAddress(clipboardData),
                    icon: "clipboard",
                    onTap: () => pasteAddress(),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "or",
                    style: AppTextStyles.textSM
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 5),
                ],
                ButtonSecondaryMD(
                  label: "Scan QR Code",
                  icon: 'qrcode',
                  onTap: _startQRScanner,
                ),
                const SizedBox(height: 30),
                ButtonOrangeLG(
                  label: "Continue",
                  onTap: () => onContinue(),
                  isEnabled: isButtonEnabled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
