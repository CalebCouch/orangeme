import 'package:flutter/material.dart';
import 'package:orange/screens/non_premium/receive.dart';
import 'package:orange/screens/non_premium/send1.dart';
import 'dart:convert';
import 'dart:async';

import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/widgets/transaction_list.dart';
import 'package:orange/widgets/value_display.dart';
import 'package:orange/widgets/receive_send.dart';
import 'package:orange/widgets/mode_navigator.dart';

class Transaction {
  final String? receiver;
  final String? sender;
  final String txid;
  final int net;
  final int fee;
  final DateTime? timestamp;
  final String? raw;

  Transaction({
    this.receiver,
    this.sender,
    required this.txid,
    required this.net,
    required this.fee,
    this.timestamp,
    this.raw,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      receiver: json['receiver'],
      sender: json['sender'],
      txid: json['txid'],
      net: json['net'],
      fee: json['fee'],
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      raw: json['raw'],
    );
  }
}

class Dashboard extends StatefulWidget {
  final bool? loading;

  const Dashboard({Key? key, this.loading}) : super(key: key);

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late Timer refreshTimer;
  final transactions = ValueNotifier<List<Transaction>>([]);
  final balance = ValueNotifier<int>(0);
  final price = ValueNotifier<double>(0);
  bool loading = false;
  int navIndex = 0;

  @override
  void initState() {
    super.initState();
    loading = widget.loading ?? false;
    handleRefresh();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    _stopTimer();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startTimer();
    } else if (state == AppLifecycleState.paused) {
      _stopTimer();
    }
  }

  void startTimer() {
    _stopTimer();
    refreshTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (mounted) {
        handleRefresh();
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    refreshTimer.cancel();
  }

  Future<void> handleRefresh() async {
    if (!mounted) return;
    startTimer();
    print('Refresh Initiated...');

    var descriptorsRes = await STORAGE.read(key: "descriptors");
    print("descriptorRes: $descriptorsRes");
    var descriptors = handleNull(descriptorsRes, context);

    print('Getting Balance...');
    var balanceRes = (await invoke("get_balance", "")).data;
    balance.value = int.tryParse(balanceRes) ?? 0;
    print("My Balance: $balanceRes");

    print('Getting Transactions...');
    var transactionsRes = (await invoke("get_transactions", "")).data;
    print("Transactions Response: $transactionsRes");

    try {
      final List<dynamic> transactionJson = jsonDecode(transactionsRes)['data'];
      final List<Transaction> transactionList = transactionJson
          .map((item) => Transaction.fromJson(item))
          .toList();
      transactions.value = transactionList;
      sortTransactions(false);
      print("Transactions: ${transactions.value}");
    } catch (e) {
      print("Error decoding transactions: $e");
    }

    print('Getting Price...');
    var priceRes = (await invoke("get_price", "")).data;
    price.value = double.tryParse(priceRes) ?? 0.0;
    print("Price: ${price.value}");

    if (loading) {
      setState(() {
        loading = false;
      });
    }
  }

  void sortTransactions(bool ascending) {
    transactions.value.sort((a, b) {
      if (a.timestamp == null && b.timestamp == null) return 0;
      if (a.timestamp == null) return -1;
      if (b.timestamp == null) return 1;
      return ascending
          ? a.timestamp!.compareTo(b.timestamp!)
          : b.timestamp!.compareTo(a.timestamp!);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (refreshTimer != null && !refreshTimer.isActive) {
      startTimer();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Wallet'),
        automaticallyImplyLeading: false,
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
                                transactions.value.isEmpty
                                    ? const Text('No transactions')
                                    : transactionsList(transactions, price),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ReceiveSend(
                                    receiveRoute: () => Receive(
                                      onDashboardPopBack: dashboardPopBack,
                                    ),
                                    sendRoute: () => Send1(
                                      balance: balance.value,
                                      price: price.value,
                                      onDashboardPopBack: dashboardPopBack,
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
          onDashboardPopBack: dashboardPopBack,
          stopTimer: _stopTimer,
        ),
      ),
    );
  }

  String formatSatsToDollars(int sats, double price) {
    double amount = (sats / 100000000) * price;
    return "${amount >= 0 ? '' : '- '}${amount.abs().toStringAsFixed(2)}";
  }

  void dashboardPopBack() async {
    await Future.delayed(const Duration(seconds: 2));
    await handleRefresh();
  }
}
