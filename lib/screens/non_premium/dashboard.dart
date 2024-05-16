import 'package:flutter/material.dart';
import 'package:orange/screens/savings/savings_dashboard.dart';
import 'package:orange/screens/settings/backup.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/styles/constants.dart';
import 'receive.dart';
import 'send1.dart';
import 'premium.dart';
import 'package:intl/intl.dart';
import 'package:orange/screens/settings/import_cloud.dart';
import 'package:orange/screens/settings/duplicate_phone.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

import 'dart:convert';
import 'dart:async';
import 'dart:core';
import 'package:orange/widgets/dashboard_value.dart';
import 'package:orange/widgets/receive_send.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  Timer? _timer;

  late AnimationController _controller;
  late PageController _pageController;
  int _currentIndex = 0;
  final _pageViewNotifier = ValueNotifier<int>(0);

  final transactions = ValueNotifier<List<Transaction>>([]);
  final expanded_txid = ValueNotifier<String?>(null);
  final balance = ValueNotifier<int>(0);
  final price = ValueNotifier<double>(0);
  bool initialLoad = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pageController = PageController(initialPage: _currentIndex);
    _timer = Timer(const Duration(seconds: 0), () => HandleRefresh());
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> FakeSpinner() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> HandleRefresh() async {
    print('Refresh Initiatied...');
    var descriptors =
        HandleNull(await STORAGE.read(key: "descriptors"), context);
    String path = await GetDBPath();
    if (initialLoad == false) {
      print('Sync Wallet...');
      HandleError(
          await invoke(method: "sync_wallet", args: [path, descriptors]),
          context);
    } else if (initialLoad == true) {
      setState(() {
        initialLoad = false;
      });
    }
    print('Getting Balance...');
    balance.value = int.parse(HandleError(
        await invoke(method: "get_balance", args: [path, descriptors]),
        context));

    print('Getting Transactions...');
    String json = HandleError(
        await invoke(method: "get_transactions", args: [path, descriptors]),
        context);
    print("json: ${json}");
    final Iterable decodeJson = jsonDecode(json);
    transactions.value =
        decodeJson.map((item) => Transaction.fromJson(item)).toList();
    sortTransactions(false);
    print(transactions.value);

    print('Getting Price...');
    price.value = double.parse(HandleError(
        await invoke(method: "get_price", args: [descriptors]), context));

    _timer = Timer(const Duration(seconds: 15), () => HandleRefresh());
  }

  //used to format a unix timestamp into either a string representing unconfirmed or a standard date time
  String FormatTimestamp(DateTime? time) {
    if (time == null) {
      return "Pending";
    } else {
      var formattedDate = DateFormat('MM/dd/yyyy').format(time);
      return formattedDate;
    }
  }

  String FormatSatsToDollars(int sats, double price) {
    return (((sats) / 100000000) * price).toStringAsFixed(2);
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

  void navigateBackUp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const BackUp()));
  }

  void navigateDuplicate() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DuplicatePhone()));
  }

  void navigateImportOptOut() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ImportCloud()));
  }

  Widget Transactions() {
    return ValueListenableBuilder<List<Transaction>>(
      valueListenable: transactions,
      builder: (BuildContext context, List<Transaction> value, child) {
        return Expanded(
          child: ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              return BuildTransactionCard(value[index]);
            },
          ),
        );
      },
    );
  }

  Widget BuildTransactionCard(Transaction transaction) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Check if the current transaction is already expanded
          if (expanded_txid.value == transaction.txid) {
            // If it is, set expanded_txid to null to collapse it
            expanded_txid.value = null;
          } else {
            // Otherwise, expand it
            expanded_txid.value = transaction.txid;
          }
        });
      },
      child: Card(
        color: Colors.grey[900],
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: FormatTimestamp(transaction.timestamp),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ])),
              ValueListenableBuilder<double>(
                valueListenable: price,
                builder: (BuildContext context, double value, child) {
                  return Text(
                    "  ${transaction.net} sats  (\$ ${FormatSatsToDollars(transaction.net, value)} )",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: (transaction.net) < 0 ? Colors.red : Colors.green,
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              ValueListenableBuilder<String?>(
                valueListenable: expanded_txid,
                builder: (BuildContext context, String? value, child) {
                  if (value != null && transaction.txid == value) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TXID: ${transaction.txid}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Timestamp: ${FormatTimestamp(transaction.timestamp)}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fee: ${transaction.fee}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  }
                  return Column();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const TextMarkLG(),
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
      body: RefreshIndicator(
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
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                        _pageViewNotifier.value = index;
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DashboardValue(
                                  fiatAmount: FormatSatsToDollars(
                                      balance.value, price.value),
                                  quantity: (balance.value / 100000000)),
                              const SizedBox(height: 10),
                              Transactions(),
                              const SizedBox(width: 10),
                              ReceiveSend(
                                receiveRoute: () => Receive(),
                                sendRoute: () => Send1(balance: balance.value),
                              )
                            ],
                          ),
                        ),
                        Premium(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.grey[800],
      //   selectedItemColor: Colors.orange,
      //   unselectedItemColor: Colors.white,
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //       _pageController.animateToPage(
      //         index,
      //         duration: const Duration(milliseconds: 500),
      //         curve: Curves.easeInOut,
      //       );
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.attach_money),
      //       label: 'Spending',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.security),
      //       label: 'Savings',
      //     ),
      //   ],
      // ),
    );
  }
}
