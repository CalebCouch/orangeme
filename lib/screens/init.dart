import 'package:flutter/material.dart';
import 'package:orange/V2/DashBoard.dart';
//import 'non_premium/dashboard.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'dart:io';

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
    print('Welcome Page loaded');
    print('Checking for seed...');
    onPageLoad();
  }

  void onPageLoad() async {
    checkPlatform();
    setState(() {
      loading = false;
    });
  }

  void messges() async {
    var message;
    message.value = (await invoke("messages", "")).data;
    print(message);
  }

  void dropseed() async {
    await invoke("drop_descs", "");
    print("dropped");
  }

  void estimateFees() async {
    text.value = (await invoke("get_price", "")).data;
    print(text.value);
  }

  void historical_price() async {
    var historical_prices;
    historical_prices.value = (await invoke("get_historical_price", "")).data;
    print(historical_prices.value);
  }

  void get_balance() async {
    var get_balance;
    get_balance.value = (await invoke("get_balance", "")).data;
    print(get_balance.value);
  }

  void get_address() async {
    var address;
    address.value = (await invoke("get_address", "")).data;
    print(address.value);
  }

  void get_new_address() async {
    var new_address;
    new_address.value = (await invoke("get_new_address", "")).data;
    print(new_address.value);
  }

  void check_address() async {
    var check_address;
    check_address.value = (await invoke("check_address", "")).data;
    print(check_address.value);
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
            builder: (context) => const Dashboard(loading: true)));
  }

  @override
  Widget build(BuildContext context) {
    checkError(context);
    return Scaffold(
      body: SingleChildScrollView(
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
                    style: Theme.of(context).textTheme.displayLarge,
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
                    onPressed: () => {dropseed()},
                    child: const Text('drop'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => {estimateFees()},
                    child: const Text('estimate fee'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => {messges()},
                    child: const Text('messages'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => {historical_price()},
                    child: const Text('Historical price'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => {get_balance()},
                    child: const Text('balance'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => {get_address()},
                    child: const Text('address'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => {get_new_address()},
                    child: const Text('New address'),
                  ),
                   const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => {check_address()},
                    child: const Text('Check address'),
                  ),
                ],
              ),
      ),
    );
  }
}
