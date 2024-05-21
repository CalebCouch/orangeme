import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:orange/screens/non_premium/receive.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'send3.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';

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
  late QRViewController controller;
  final TextEditingController recipientAddressController =
      TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _isSending = false;
  bool isAddressValid = false;

  @override
  void initState() {
    super.initState();
    recipientAddressController.addListener(trimAddressPrefix);
    recipientAddressController.addListener(checkAddress);
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

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      print('Scanned Data: ${scanData.code}');
      recipientAddressController.text = scanData.code ?? '';
      await controller.stopCamera(); // Stop the camera
      Navigator.of(context).pop(); // Close the QR code scanner dialog
    });
  }

  void trimAddressPrefix() {
    String currentText = recipientAddressController.text;
    if (currentText.startsWith('bitcoin:')) {
      //remove the bitcoin: prefix if applicable
      String updatedText = currentText.substring(8);
      recipientAddressController.value = TextEditingValue(
        text: updatedText,
        selection: TextSelection.collapsed(offset: updatedText.length),
      );
    }
  }

  Future<void> checkAddress() async {
    print("address check:");
    var res = HandleError(
        await invoke(
            method: "check_address", args: [recipientAddressController.text]),
        context);
    if (res == "true") {
      setState(() {
        isAddressValid = true;
      });
      FocusScope.of(context).unfocus();
    } else {
      setState(() {
        isAddressValid = false;
      });
    }
  }

  void createTransaction() async {
    var desc = await STORAGE.read(key: "descriptors");
    String db = await GetDBPath();
    if (desc != null) {
      print("database: $db");
      print("descriptor: $desc");
      print("Address: ${recipientAddressController.text}");
      print("Amount: ${widget.amount}");
      var json = HandleError(
          await invoke(method: "create_transaction", args: [
            db.toString(),
            desc.toString(),
            recipientAddressController.text.toString(),
            widget.amount.round().toString()
          ]),
          context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Send3(tx: json),
        ),
      );
    }
    print("building tx and sending user to confirmation screen");
  }

  void resetField() {
    recipientAddressController.clear();
  }

  void _stopQRScanner() {
    Navigator.pop(context);
    controller.dispose();
  }

  @override
  void dispose() {
    recipientAddressController.dispose();
    _noteController.dispose();
    _stopQRScanner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Amount to send: ${widget.amount}");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Destination',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  _startQRScanner();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 0, 0, 131),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.qr_code,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: recipientAddressController,
                decoration: InputDecoration(
                  hintText: 'Enter recipient address',
                  suffixIcon: isAddressValid
                      ? const Icon(Icons.check, color: Colors.green)
                      : IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: resetField,
                        ),
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[900],
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: 'Add a note (optional)',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[900],
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              _isSending
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: isAddressValid ? createTransaction : null,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Colors.grey; // Gray when disabled
                            }
                            return Colors.orange; // Bright orange when enabled
                          },
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
