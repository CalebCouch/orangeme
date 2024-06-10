import 'package:flutter/material.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
// import 'package:orange/styles/constants.dart';
import 'receive.dart';
import 'send1.dart';
import 'package:orange/widgets/transaction_list.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:core';
import 'package:orange/widgets/value_display.dart';
import 'package:orange/widgets/receive_send.dart';
import 'package:orange/widgets/mode_navigator.dart';

// import 'package:orange/screens/settings/import_cloud.dart';
// import 'package:orange/screens/settings/duplicate_phone.dart';
// import 'package:orange/screens/settings/backup.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Timer? refreshTimer;
  final transactions = ValueNotifier<List<Transaction>>([]);
  final balance = ValueNotifier<int>(0);
  final price = ValueNotifier<double>(0);
  bool initialLoad = true;
  bool loading = true;
  int navIndex = 0;

  @override
  void initState() {
    print("INITIALIZING DASHBOARD");
    super.initState();
    //sync and obtain data on page load
    handleRefresh();
    //monitor for application reactivation and init
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    print("DISPOSING DASHBOARD");
    //dispose of the dashboard refresh timer
    _stopTimer();
    //monitor for application minimizing and dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //this is used to stop the refresh timer from running while the program is minimized
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("widgets binding observer thrown");
    if (state == AppLifecycleState.resumed) {
      print("starting refresh timer due to life cycle change");
      startTimer();
    } else if (state == AppLifecycleState.paused) {
      print("stopping refresh timer due to life cycle change");
      _stopTimer();
    }
  }

  //start the timer to periodically get a data refresh
  void startTimer() {
    print("request to start dashboard refresh timer....");
    if (refreshTimer == null || !refreshTimer!.isActive) {
      refreshTimer = Timer(const Duration(seconds: 15), () {
        print("dashboard refresh was not running... timer started");
        if (mounted) {
          handleRefresh();
        } else {
          print("unmounted parent, stopping dashboard refresh timer");
          _stopTimer();
        }
      });
    } else {
      print("Timer is already active, no need to start another");
    }
  }

  //stop the timer controlling the data refresh
  void _stopTimer() {
    print("stopping dashboard refresh timer...");
    refreshTimer?.cancel();
  }

  //sync wallet and get transaction list, current price, and balance
  Future<void> handleRefresh() async {
    if (!mounted) return;
    if (refreshTimer == null || !refreshTimer!.isActive) {
      startTimer();
    }
    print('Refresh Initiatied...');
    var descriptorsRes = await STORAGE.read(key: "descriptors");
    print("descriptorRes: $descriptorsRes");
    if (!mounted) return;
    var descriptors = handleNull(descriptorsRes, context);
    String path = await getDBPath();
    if (initialLoad == false) {
      print('Sync Wallet...');
      //sync wallet data
      var syncRes =
          await invoke(method: "sync_wallet", args: [path, descriptors]);
      print("SyncRes: $syncRes");
      if (!mounted) return;
      handleError(syncRes, context);
    } else if (initialLoad == true) {
      setState(() {
        initialLoad = false;
      });
    }
    print('Getting Balance...');
    //get the wallet balance
    var balanceRes =
        await invoke(method: "get_balance", args: [path, descriptors]);
    print("Balanceres: $balanceRes");
    if (!mounted) return;
    balance.value = int.parse(handleError(balanceRes, context));
    print("Balance: ${balance.value}");

    print('Getting Transactions...');
    //get the wallet transaction history
    var jsonRes =
        await invoke(method: "get_transactions", args: [path, descriptors]);
    print("Transactionsres: $jsonRes");

    if (!mounted) return;
    String json = handleError(jsonRes, context);
    print("json: $json");
    final Iterable decodeJson = jsonDecode(json);
    transactions.value =
        decodeJson.map((item) => Transaction.fromJson(item)).toList();
    sortTransactions(false);
    print(transactions.value);

    print('Getting Price...');
    //get the latest price
    if (!mounted) return;
    var priceRes = await invoke(method: "get_price", args: []);
    if (priceRes.status == 200) {
      price.value = double.parse(priceRes.message);
    }
    print("Price: ${price.value}");
    if (loading == true) {
      setState(() {
        loading = false;
      });
    }
  }

  //format a number of satoshis into dollars at the current price
  String formatSatsToDollars(int sats, double price) {
    print("formatting...sats: $sats price: $price");
    double amount = (sats / 100000000) * price;
    print("formatted balance: $amount");
    return "${amount >= 0 ? '' : '- '}${amount.abs().toStringAsFixed(2)}";
  }

  // Sort transactions in ascending order with null timestamps being shown at the top
  void sortTransactions(bool ascending) {
    transactions.value.sort((a, b) {
      if (a.timestamp == null && b.timestamp == null) return 0;
      if (a.timestamp == null) return -1;
      if (b.timestamp == null) return 1;
      if (ascending == true) {
        //ascending order
        return a.timestamp!.compareTo(b.timestamp!);
      } else {
        //descending order
        return b.timestamp!.compareTo(a.timestamp!);
      }
    });
  }

  //these are used to activate the app bar menu links, currently disabled

  // void navigateBackUp() {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => const BackUp()));
  // }

  // void navigateDuplicate() {
  //   Navigator.push(context,
  //       MaterialPageRoute(builder: (context) => const DuplicatePhone()));
  // }

  // void navigateImportOptOut() {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => const ImportCloud()));
  // }

  @override
  Widget build(BuildContext context) {
    print("Refresh Timer: $refreshTimer");
    if (refreshTimer != null && refreshTimer!.isActive == false) {
      print("timer wasn't running, let me start that for you");
      startTimer();
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        // title: const TextMarkLG(),
        title: const Text('Wallet'),
        automaticallyImplyLeading: false,
        //app bar drop down settings/nav menu, currently disabled
        // actions: [
        //   PopupMenuButton<int>(
        //     icon: const Icon(Icons.menu),
        //     offset: Offset(0, AppBar().preferredSize.height),
        //     onSelected: (int result) {
        //       switch (result) {
        //         case 0:
        //           navigateBackUp();
        //           break;
        //         case 1:
        //           navigateImportOptOut();
        //           break;
        //         case 2:
        //           navigateDuplicate();
        //           break;
        //       }
        //     },
        //     itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        //       const PopupMenuItem<int>(
        //         value: 0,
        //         child: Text('Back Up'),
        //       ),
        //       const PopupMenuItem<int>(
        //         value: 1,
        //         child: Text('Import'),
        //       ),
        //       const PopupMenuItem<int>(
        //         value: 2,
        //         child: Text('Duplicate'),
        //       ),
        //     ],
        //   ),
        // ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: handleRefresh,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: true,
                    fillOverscroll: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ValueListenableBuilder<int>(
                                  valueListenable: balance,
                                  builder: (context, balanceValue, child) =>
                                      ValueListenableBuilder<double>(
                                    valueListenable: price,
                                    builder: (context, priceValue, child) =>
                                        ValueDisplay(
                                      fiatAmount: formatSatsToDollars(
                                          balanceValue, priceValue),
                                      quantity: (balanceValue / 100000000.0)
                                          .toStringAsFixed(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                transactionsList(transactions, price),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ReceiveSend(
                                    receiveRoute: () => Receive(
                                      onDashboardPopBack: handleRefresh,
                                    ),
                                    sendRoute: () => Send1(
                                      balance: balance.value,
                                      price: price.value,
                                      onDashboardPopBack: handleRefresh,
                                    ),
                                    onPause: _stopTimer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: ModeNavigator(
          navIndex: navIndex,
          onDashboardPopBack: handleRefresh,
        ),
      ),
    );
  }
}
