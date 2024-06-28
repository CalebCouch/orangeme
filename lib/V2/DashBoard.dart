import 'package:flutter/material.dart';
import 'package:orange/screens/non_premium/send1.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orange/widgets/receive_send.dart';
import 'package:orange/widgets/transaction_list.dart';
import 'package:orange/widgets/value_display.dart';
import '../screens/non_premium/receive.dart';
import 'package:orange/widgets/mode_navigator.dart';
import 'dart:convert';
import 'dart:async';

class Dashboard extends StatefulWidget {
  final bool? loading;

  const Dashboard({super.key, this.loading});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
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
    if (refreshTimer == null || !refreshTimer!.isActive) {
      refreshTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
        if (mounted) handleRefresh();
      });
    }
  }

  void _stopTimer() {
    refreshTimer?.cancel();
  }

  Future<void> handleRefresh() async {
    if (!mounted) return;
    startTimer();
    var descriptorsRes = await STORAGE.read(key: "descriptors");
    var descriptors = handleNull(descriptorsRes, context);
   // String path = await getDBPath();

   /**  await _syncWallet(path, descriptors);
    await _updateBalance(path, descriptors);
    await _updateTransactions(path, descriptors);
    await _updatePrice();
*/
    if (loading) {
      setState(() {
        loading = false;
      });
    }
  }
/** 
  Future<void> _syncWallet(String path, String descriptors) async {
    var syncRes = await invoke(method: "sync_wallet", args: [path, descriptors]);
    handleError(syncRes, context);
  }

  Future<void> _updateBalance(String path, String descriptors) async {
    var balanceRes = await invoke(method: "get_balance", args: [path, descriptors]);
    balance.value = int.parse(handleError(balanceRes, context));
  }

  Future<void> _updateTransactions(String path, String descriptors) async {
    var jsonRes = await invoke(method: "get_transactions", args: [path, descriptors]);
    String json = handleError(jsonRes, context);
    final Iterable decodeJson = jsonDecode(json);
    transactions.value = decodeJson.map((item) => Transaction.fromJson(item)).toList();
    _sortTransactions(false);
  }

  Future<void> _updatePrice() async {
    var priceRes = await invoke(method: "get_price", args: []);
    if (priceRes.status == 200) {
      price.value = double.parse(priceRes.message);
    }
  }
*/
  void _sortTransactions(bool ascending) {
    transactions.value.sort((a, b) {
      if (a.timestamp == null && b.timestamp == null) return 0;
      if (a.timestamp == null) return -1;
      if (b.timestamp == null) return 1;
      return ascending
          ? a.timestamp!.compareTo(b.timestamp!)
          : b.timestamp!.compareTo(a.timestamp!);
    });
  }

  String _formatSatsToDollars(int sats, double price) {
    double amount = (sats / 100000000) * price;
    return "\$${amount.toStringAsFixed(2)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: handleRefresh,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ValueListenableBuilder<int>(
                            valueListenable: balance,
                            builder: (context, balanceValue, child) =>
                                ValueListenableBuilder<double>(
                              valueListenable: price,
                              builder: (context, priceValue, child) =>
                                  ValueDisplay(
                                fiatAmount: _formatSatsToDollars(balanceValue, priceValue),
                                quantity: (balanceValue / 100000000.0).toStringAsFixed(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          transactionsList(transactions, price),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ReceiveSend(
                              receiveRoute: () => Receive(onDashboardPopBack: handleRefresh),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: ModeNavigator(
          navIndex: navIndex,
          onDashboardPopBack: handleRefresh,
          stopTimer: _stopTimer,
        ),
      ),
    );
  }
}
