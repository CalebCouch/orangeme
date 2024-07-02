import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/widgets/session_timer.dart';
import 'package:orange/screens/non_premium/send1.dart';
import 'package:orange/screens/non_premium/send3.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'package:orange/components/textfield.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'package:orange/components/buttons/secondary_md.dart';
import 'package:orange/styles/constants.dart';

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
  _Send2State createState() => _Send2State();
}

class _Send2State extends State<Send2> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final TextEditingController recipientAddressController =
      TextEditingController();
  bool isAddressValid = false;
  bool isButtonEnabled = false;
  String clipboardData = '';
  Timer? clipboardCheckTimer;
  Transaction? priorityTransaction;
  Transaction? standardTransaction;
  bool isCreatingTransaction = false;

  @override
  void initState() {
    super.initState();
    fetchAndValidateClipboard();
    recipientAddressController.addListener(buttonListener);
    if (widget.address != null) {
      recipientAddressController.text = widget.address!;
    }
    clipboardCheckTimer = Timer.periodic(
        const Duration(seconds: 1), (_) => fetchAndValidateClipboard());
    widget.sessionTimer.setOnSessionEnd(() {
      widget.onDashboardPopBack();
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
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

    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      String trimmedData = trimAddressPrefix(clipboardData!.text!);
      bool isValid = await checkAddress(trimmedData);
      if (isValid && mounted) {
        setState(() {
          this.clipboardData = clipboardData.text!;
        });
      } else if (mounted) {
        setState(() {
          this.clipboardData = "";
        });
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
    var checkRes = (await invoke("check_address", address)).data;
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
      controller!.dispose();
    }
    Navigator.of(context).pop();
  }

  pasteAddress() {
    recipientAddressController.text = clipboardData;
  }

  Future<void> createTransactions() async {
    if (isCreatingTransaction) return; // Avoid multiple calls
    setState(() {
      isCreatingTransaction = true;
    });

    try {
      var priorityInput = CreateTransactionInput(
        recipientAddressController.text,
        widget.amount.toString(),
        1,
      );
      var priorityJson =
          (await invoke("create_transaction", jsonEncode(priorityInput))).data;
      priorityTransaction = Transaction.fromJson(jsonDecode(priorityJson));

      var standardInput = CreateTransactionInput(
        recipientAddressController.text,
        widget.amount.toString(),
        3,
      );
      var standardJson =
          (await invoke("create_transaction", jsonEncode(standardInput))).data;
      standardTransaction = Transaction.fromJson(jsonDecode(standardJson));

      // Navigate to Send3 if both transactions are created
      if (priorityTransaction != null && standardTransaction != null) {
        _navigateToSend3();
      } else {
        // Handle case where transactions are not created
        print("Transactions are not yet created.");
      }
    } catch (e) {
      print("Error creating transactions: $e");
    } finally {
      setState(() {
        isCreatingTransaction = false;
      });
    }
  }

  void _navigateToSend3() {
    _stopTimer();
    if (mounted) {
      try {
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
              priority_tx: priorityTransaction!,
              standard_tx: standardTransaction!,
            ),
          ),
        );
      } catch (e) {
        print("Navigation error: $e");
      }
    }
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
                    amount: ((widget.amount / 100000000) * widget.price)
                        .toStringAsFixed(2),
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
                onTap: isButtonEnabled ? () => createTransactions() : null,
                isEnabled: isButtonEnabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
