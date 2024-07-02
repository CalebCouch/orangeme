import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orange/screens/error.dart';
import 'non_premium/dashboard.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'dart:io';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final text = ValueNotifier<String>("de");
  bool loading = true;
  final error = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    print('Welcome Page loaded');
    print('Checking for seed...');
    onPageLoad();
  }

  void onPageLoad() async {
    try {
      checkPlatform();
      await performInitialization();
      setState(() {
        loading = false;
      });
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> performInitialization() async {
    await Future.wait([
      messages(),
      dropSeed(),
      historicalPrice(),
      getBalance(),
      getNewAddress(),
      checkAddress(),
    ]);
  }

  Future<void> messages() async {
    var message = await invoke("messages", "");
    print(message);
  }

  Future<void> dropSeed() async {
    await invoke("drop_descs", "");
    print("dropped");
  }

  Future<void> historicalPrice() async {
    var historicalPrices = await invoke("get_historical_price", "");
    print(historicalPrices.data);
  }

  Future<void> getBalance() async {
    var balance = await invoke("get_balance", "");
    print(balance.data);
  }

  Future<String> getNewAddress() async {
    var newAddress = await invoke("get_new_address", "");
    print(newAddress.data);
    return newAddress.data;
  }

  Future<void> checkAddress() async {
    var newAddress = await getNewAddress();
    var checkAddress = await invoke("check_address", newAddress);
    print(checkAddress.data);
  }

  void handleError(dynamic error) {
    print('Error: $error');
    this.error.value = error.toString();
    setState(() {
      loading = false;
    });
  }

  void checkPlatform() {
    if (Platform.isAndroid) {
      print("Android device detected");
    } else if (Platform.isIOS) {
      print("IOS device detected");
    } else if (Platform.isLinux) {
      print("Linux device detected");
    } else if (Platform.isMacOS) {
      print("Mac OS device detected");
    } else if (Platform.isWindows) {
      print("Windows device detected");
    } else if (Platform.isFuchsia) {
      print("Fuchsia device detected");
    }
  }

  void navigate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Dashboard(loading: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<String>(
        valueListenable: error,
        builder: (context, errorMessage, _) {
          if (errorMessage != "") {
            return ErrorPage(message: errorMessage);
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Welcome to Orange. This screen will not normally be seen and is used for initialization',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ValueListenableBuilder<String>(
                          valueListenable: text,
                          builder: (BuildContext context, String value, child) {
                            return Text(
                              "$value Sats",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.center,
                            );
                          },
                        ),
                         ElevatedButton(
                          onPressed: navigate,
                          child: const Text('Proceed'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: dropSeed,
                          child: const Text('Drop'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: messages,
                          child: const Text('Messages'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: historicalPrice,
                          child: const Text('Historical Price'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: getBalance,
                          child: const Text('Balance'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: getNewAddress,
                          child: const Text('New Address'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: checkAddress,
                          child: const Text('Check Address'),
                        ),
                        const SizedBox(height: 20),
                       
                      ],
                    ),
            );
          }
        },
      ),
    );
  }
}

