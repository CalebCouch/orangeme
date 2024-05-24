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
  final int amount;
  final int balance;
  const Send2({
    super.key,
    required this.amount,
    required this.balance,
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
    recipientAddressController.addListener(buttonListner);
    clipboardCheckTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        fetchAndValidateClipboard();
      }
    });
  }

  //used to periodically parse the users clipboard for display within an onscreen button
  Future<void> fetchAndValidateClipboard() async {
    //will only fire if the widget lifecyle is still mounted (prevents async errors when navigating away)
    if (!mounted) return;
    print("Checking Clipboard Data");
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      //trim 'bitcoin:' address prefixes
      String trimmedData = trimAddressPrefix(clipboardData!.text);
      //the address will only populate the button if it first passes this valid btc address check
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

  //starts the qr code scanner and builds the dialog box
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

  //handles the data intercepted by a good QR code scan
  void _onQRViewCreated(QRViewController newController) {
    controller = newController;
    controller!.scannedDataStream.listen((scanData) async {
      print('Scanned Data: ${scanData.code}');
      //trim "bitcoin:" address prefix
      String trimmed = trimAddressPrefix(scanData.code);
      //the address will only populate the text field if it first passes this valid btc address check
      var validAddress = await checkAddress(trimmed);
      if (validAddress) {
        recipientAddressController.text = trimmed;
      }
      // Stop the camera
      await controller!.stopCamera();
      closeDialog(); // Close the QR code scanner dialog
    });
  }

  //close the QR code dialog window & dispose the controller
  void closeDialog() {
    if (controller != null && mounted) {
      print("controller disposed");
      controller!.dispose();
    }
    Navigator.of(context).pop();
  }

  //paste the contents of the users clipboard into the address text input field
  pasteAddress() {
    recipientAddressController.text = clipboardData;
  }

  //used to check for and then trim the "bitcoin:" address prefix included on some addresses
  String trimAddressPrefix(String? contents) {
    if (contents!.startsWith('bitcoin:')) {
      //remove the bitcoin: prefix if applicable
      String updatedText = contents.substring(8);
      return updatedText;
    } else {
      return contents;
    }
  }

  //check whether or not a string is a valid bitcoin address
  Future<bool> checkAddress(String address) async {
    print("address check:");
    var checkRes = await invoke(method: "check_address", args: [address]);
    if (!mounted) return false;
    var check = handleError(checkRes, context);
    return check == "true";
  }

  //watches for updates to the address text field and validates the address to enable/disable the continue button
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

  //navigate to the next page in the send flow
  void onContinue() {
    _stopTimer(); //prevents clipboard parse from running off screen
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Send3(
                amount: widget.amount,
                address: recipientAddressController.text,
                balance: widget.balance)));
  }

  //used to shorten a bitcoin address on the users clipboard for button display
  String truncateAddress(address) {
    if (address.length > 30) {
      final firstPart = address.substring(0, 15);
      return '$firstPart...';
    }
    return address;
  }

  //stops the QR code scanner
  void _stopQRScanner() {
    if (controller != null) {
      Navigator.pop(context);
      controller!.dispose();
    }
  }

  //used to stop the clipbard parse timer
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
      //prevents clipboard refresh timer from continuing to run off screen
      onPopInvoked: (bool didPop) async {
        _stopTimer();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Bitcoin Address'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextInputField(
                controller: recipientAddressController,
                hint: "Bitcoin address...",
              ),
              const SizedBox(height: 10),
              //only show this section if the user's clipboard contains a valid BTC address
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
              const Spacer(),
              ButtonOrangeLG(
                label: "Continue",
                onTap: () => onContinue(),
                isEnabled: isButtonEnabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
