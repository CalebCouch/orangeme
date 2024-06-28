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
import 'package:orange/widgets/session_timer.dart';
import 'package:orange/screens/non_premium/send1.dart';

class Send2 extends StatefulWidget {
  final int amount;
  final int balance;
  final double price;
  final VoidCallback onDashboardPopBack;
  final SessionTimerManager sessionTimer;
  final String? address;
  const Send2(
      {super.key,
      required this.amount,
      required this.balance,
      required this.price,
      required this.onDashboardPopBack,
      required this.sessionTimer,
      this.address});

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
    print("initializing send2");
    super.initState();
    fetchAndValidateClipboard();
    recipientAddressController.addListener(buttonListner);
    //this condition applies if user is returning from further in the flow
    if (widget.address != null) {
      recipientAddressController.text = widget.address!;
    }
    //check the users clipboard contents every 1 second
    clipboardCheckTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        fetchAndValidateClipboard();
      }
    });
    //send user back to dashboard if session expires
    widget.sessionTimer.setOnSessionEnd(() {
      if (mounted) {
        widget.onDashboardPopBack();
        Navigator.pop(context);
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
                balance: widget.balance,
                price: widget.price,
                onDashboardPopBack: widget.onDashboardPopBack,
                sessionTimer: widget.sessionTimer)));
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
    print("stop clipboard check timer...");
    clipboardCheckTimer?.cancel();
  }

  @override
  void dispose() {
    print("disposing send2");
    recipientAddressController.dispose();
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Time left ${widget.sessionTimer.getTimeLeftFormatted()}");
    print("Amount to send: ${widget.amount}");
    return PopScope(
      canPop: true,
      //prevents clipboard refresh timer & session timer from continuing to run off screen
      onPopInvoked: (bool didPop) async {
        _stopTimer();
        widget.sessionTimer.dispose();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Bitcoin Address'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Send1(
                              price: widget.price,
                              balance: widget.balance,
                              onDashboardPopBack: widget.onDashboardPopBack,
                              sessionTimer: widget.sessionTimer,
                              amount:
                                  ((widget.amount / 100000000) * widget.price)
                                      .toStringAsFixed(2),
                            )));
              }),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextInputField(
                  controller: recipientAddressController,
                  hint: "Bitcoin address...",
                  error: 'invalid address'),
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
