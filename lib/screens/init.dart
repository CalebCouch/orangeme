import 'package:flutter/material.dart';
import 'package:orange/flows/wallet_flow/send_flow/send.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'dart:io';

import 'package:orange/flows/wallet_flow/home.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  InitPageState createState() => InitPageState();
}

class InitPageState extends State<InitPage> {
  final text = ValueNotifier<String>("de");
  bool loading = true;

  @override
  void initState() {
    super.initState();
    // ignore: unused_local_variable
    print('Welcome Page loaded');
    print('Checking for seed...');
    onPageLoad();
  }

  void onPageLoad() async {
    checkPlatform();
    var descriptors = await STORAGE.read(key: "descriptors");
    print("read from DB");
    if (descriptors == null) {
      var descriptorsRes =
          await invoke(method: "get_new_singlesig_descriptor", args: []);
      if (!mounted) return;
      descriptors = handleError(descriptorsRes, context);
      await STORAGE.write(key: "descriptors", value: descriptors);
    }
    print("desc: $descriptors");
    String path = await getDBPath();
    print('Syncing Wallet...');
    var syncRes =
        await invoke(method: "sync_wallet", args: [path, descriptors]);
    if (!mounted) return;
    handleError(syncRes, context);
    setState(() {
      loading = false;
    });
  }

  void genSeed() async {
    var descriptorsRes =
        await invoke(method: "get_new_singlesig_descriptor", args: []);
    if (!mounted) return;
    var descriptors = handleError(descriptorsRes, context);
    await STORAGE.write(key: "descriptors", value: descriptors);
    print("desc: $descriptors");
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

  void dropDB() async {
    print("dropdb");
    var descriptorsRes = await STORAGE.read(key: "descriptors");
    if (!mounted) return;
    handleNull(descriptorsRes, context);
    //await dropdb(path: path, descriptors: descriptors);
    print("dropeddb");
  }

  void estimateFees() async {
    print("estimating fees");
    var feesRes = await invoke(method: "estimate_fees", args: []);
    if (!mounted) return;
    var fees = handleError(feesRes, context);
    print("Fees: $fees");
  }

  void throwError() async {
    var errorRes = await invoke(method: "throw_error", args: []);
    if (!mounted) return;
    handleError(errorRes, context);
  }

  void navigate() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WalletHome()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Enables scrolling
        padding: const EdgeInsets.all(16.0),
        child: loading
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const Center(child: CircularProgressIndicator()))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Welcome to Orange. This screen will not normally be seen and is used for initialization',
                    style: TextStyle(
                        fontSize: TextSize.lg, color: ThemeColor.bitcoin),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => {navigate()},
                    child: const Text('Proceed'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => {},
                    child: const Text(
                      'Gendesc(disabled)',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => {throwError()},
                    child: const Text('Error'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => {dropDB()},
                    child: const Text('drop'),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () => {estimateFees()},
                    child: const Text('estimate fee'),
                  ),
                ],
              ),
      ),
    );
  }
}
