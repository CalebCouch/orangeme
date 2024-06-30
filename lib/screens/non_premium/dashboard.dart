import 'package:flutter/material.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'receive.dart';
import 'send1.dart';
import 'package:orange/widgets/transaction_list.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:core';
import 'package:orange/widgets/value_display.dart';
import 'package:orange/widgets/receive_send.dart';
import 'package:orange/widgets/mode_navigator.dart';

class Dashboard extends StatefulWidget {
  final bool? loading;

  const Dashboard({super.key, this.loading});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Timer? refreshTimer;
  final transactions = ValueNotifier<List<Transaction>>([]);
  final balance = ValueNotifier<int>(0);
  final price = ValueNotifier<double>(0);
  bool loading = false;
  int navIndex = 0;

  @override
  void initState() {
    print("INITIALIZING DASHBOARD");
    super.initState();
    loading = widget.loading ?? false;
    handleRefresh();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    print("DISPOSING DASHBOARD");
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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

  void startTimer() {
    print("request to start dashboard refresh timer....");
    _stopTimer();
    refreshTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      print("dashboard refresh timer tick");
      if (mounted) {
        handleRefresh();
      } else {
        print("unmounted parent, stopping dashboard refresh timer");
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    print("stopping dashboard refresh timer...");
    refreshTimer?.cancel();
    refreshTimer = null;
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
    print("Balanceres: $balanceRes");

    print('Getting Transactions...');
    var jsonRes = (await invoke("get_transactions", "")).data;
    sortTransactions(false);
    print(transactions.value);

    print('Getting Price...');
    var priceRes = (await invoke("get_price", "")).data;
    // price.value = double.parse(priceRes.message);
    print("Price: ${price.value}");
    
    if (loading) {
      setState(() {
        print("loading set to false");
        loading = false;
      });
    }
  }

  void dashboardPopBack() async {
    await Future.delayed(const Duration(seconds: 2));
    await handleRefresh();
  }

  String formatSatsToDollars(int sats, double price) {
    print("formatting...sats: $sats price: $price");
    double amount = (sats / 100000000) * price;
    print("formatted balance: $amount");
    return "${amount >= 0 ? '' : '- '}${amount.abs().toStringAsFixed(2)}";
  }

  void sortTransactions(bool ascending) {
    transactions.value.sort((a, b) {
      if (a.timestamp == null && b.timestamp == null) return 0;
      if (a.timestamp == null) return -1;
      if (b.timestamp == null) return 1;
      return ascending ? a.timestamp!.compareTo(b.timestamp!) : b.timestamp!.compareTo(a.timestamp!);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Refresh Timer: $refreshTimer");
    if (refreshTimer != null && !refreshTimer!.isActive) {
      print("timer wasn't running, let me start that for you");
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
                                transactionsList(transactions, price),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
}
