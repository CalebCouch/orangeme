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
  const Send2({
    Key? key,
    required this.amount,
    required this.balance,
    required this.price,
    required this.onDashboardPopBack,
    required this.sessionTimer,
    this.address,
  }) : super(key: key);

  @override
  Send2State createState() => Send2State();
}

class Send2State extends State<Send2> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final TextEditingController recipientAddressController =
      TextEditingController();
  bool isAddressValid = false;
  bool isButtonEnabled = false;
  String clipboardData = '';
  Timer? clipboardCheckTimer;

  @override
  void initState() {
    super.initState();
    print("initializing send2");
    fetchAndValidateClipboard();
    recipientAddressController.addListener(buttonListener);
    if (widget.address != null) {
      recipientAddressController.text = widget.address!;
    }
    clipboardCheckTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => fetchAndValidateClipboard());
    widget.sessionTimer.setOnSessionEnd(() {
      widget.onDashboardPopBack();
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    print("disposing send2");
    recipientAddressController.dispose();
    _stopTimer();
    _stopQRScanner();
    super.dispose();
  }

  void _stopTimer() {
    clipboardCheckTimer?.cancel();
  }

  void _stopQRScanner() {
    controller?.dispose();
  }

  Future<void> fetchAndValidateClipboard() async {
    if (!mounted) return;

    print("Checking Clipboard Data");
    ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      String trimmedData = trimAddressPrefix(clipboardData!.text!);
      bool isValid = await checkAddress(trimmedData);
      if (isValid) {
        // Ensure setState is called only when mounted
        if (mounted) {
          setState(() {
            this.clipboardData = clipboardData.text!;
          });
        }
      } else {
        // Ensure setState is called only when mounted
        if (mounted) {
          setState(() {
            this.clipboardData = "";
          });
        }
      }
    }
  }

  void buttonListener() async {
    bool isValid = await checkAddress(recipientAddressController.text);
    if (mounted) {
      setState(() {
        isButtonEnabled = isValid;
      });
    }
  }

  String trimAddressPrefix(String? contents) {
    if (contents!.startsWith('bitcoin:')) {
      return contents.substring(8);
    } else {
      return contents;
    }
  }

  Future<bool> checkAddress(String address) async {
    print("address check:");
    var checkRes = (await invoke("check_address", address)).data;
    print(address);
    print(checkRes);
    if (!mounted) return false;
    return checkRes == "true";
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
                Navigator.pop(context);
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
      await controller!.stopCamera();
      closeDialog();
    });
  }

  void closeDialog() {
    if (controller != null && mounted) {
      print("controller disposed");
      controller!.dispose();
    }
    Navigator.of(context).pop();
  }

  pasteAddress() {
    recipientAddressController.text = clipboardData;
  }

  void onContinue() {
    _stopTimer();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Send3(
          amount: widget.amount,
          address: recipientAddressController.text,
          balance: widget.balance,
          price: widget.price,
          onDashboardPopBack: widget.onDashboardPopBack,
          sessionTimer: widget.sessionTimer,
        ),
      ),
    );
  }

  String truncateAddress(String address) {
    if (address.length > 30) {
      final firstPart = address.substring(0, 15);
      return '$firstPart...';
    }
    return address;
  }

  @override
  Widget build(BuildContext context) {
    print("Time left ${widget.sessionTimer.getTimeLeftFormatted()}");
    print("Amount to send: ${widget.amount}");
    return PopScope(
      canPop: true,
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
                    amount: ((widget.amount / 100000000) * widget.price).toStringAsFixed(2),
                  ),
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextInputField(
                controller: recipientAddressController,
                hint: "Bitcoin address...",
                error: 'invalid address',
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
                  style: AppTextStyles.textSM.copyWith(color: AppColors.textSecondary),
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
