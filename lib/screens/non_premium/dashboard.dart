import 'package:flutter/material.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'receive.dart';
import 'send1.dart';
import 'package:orange/widgets/transaction_list.dart';
import 'dart:convert';
import 'dart:async';
import 'package:orange/widgets/value_display.dart';
import 'package:orange/widgets/receive_send.dart';
import 'package:orange/widgets/mode_navigator.dart';

class Dashboard extends StatefulWidget {
  final bool? loading;

  const Dashboard({Key? key, this.loading}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Timer? refreshTimer;
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
      handleRefresh();
    });
  }

  void _stopTimer() {
    refreshTimer?.cancel();
    refreshTimer = null;
  }

  Future<void> handleRefresh() async {
    try {
      var balanceRes = (await invoke("get_balance", "")).data;
      balance.value = int.parse(balanceRes);
      print("My Balance: $balanceRes");

      var transactionsRes = await invoke("get_transactions", "");
      var jsonRes = transactionsRes.data;
      List<dynamic> transactionList = jsonDecode(jsonRes);
      transactions.value =
          transactionList.map((item) => Transaction.fromJson(item)).toList();
      print("Transactions: ${transactions.value}");

      var priceRes = (await invoke("get_price", "")).data;
      price.value = double.parse(priceRes);
      print("Price: $priceRes");

      if (loading) {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print("Error during refresh: $e");
      // Handle error appropriately, e.g., show error message to the user
    }
  }

  void dashboardPopBack() async {
    await Future.delayed(const Duration(seconds: 2));
    await handleRefresh();
  }

  String formatSatsToDollars(int sats, double price) {
    double amount = (sats / 100000000) * price;
    return "${amount >= 0 ? '' : '- '}${amount.abs().toStringAsFixed(2)}";
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
    if (refreshTimer != null && !refreshTimer!.isActive) {
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
                                    ? Center(child: Text('No transactions'))
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
}
