import 'package:flutter/material.dart';
import 'dart:async';
import '../settings/settings.dart';
import '../savings/savings_dashboard.dart';
import 'package:intl/intl.dart';
import 'spending_receive.dart';
import 'spending_send.dart';
import 'threshold_popup.dart';

// class ExpandableTransaction {
//   final TransactionDetails transaction;
//   bool isExpanded;

//   ExpandableTransaction({
//     required this.transaction,
//     this.isExpanded = false,
//   });
// }

class SpendingDashboard extends StatefulWidget {
  const SpendingDashboard({super.key});

  @override
  State<SpendingDashboard> createState() => _SpendingDashboardState();
}

class _SpendingDashboardState extends State<SpendingDashboard>
    with TickerProviderStateMixin {
  String mnemonic = '';
  String? displayText;
  // List<ExpandableTransaction> transactions = [];
  List transactions = [];
  int balance = 12345678;
  final bool _isLoading = false;
  int price = 47085;
  late AnimationController _controller;
  int _currentIndex = 0;
  late PageController _pageController;
  final _pageViewNotifier = ValueNotifier<int>(0);
  Timer? _timer;
  //hardcoded for now
  bool premium = false;
  //hardcoded, adjust downward relative to balance to see threshold popup, adjust upwards to disable
  int threshold = 500000;
  bool thresholdExceeded = false;
  bool optedOut = false;
  bool showChallenge = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pageController = PageController(initialPage: _currentIndex);
    onPageLoad();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void premiumChallenge() {
    //evluate here
    bool premium = false;
    if (premium == true) {
      //show premium wallet
    } else {
      //show free wallet
    }
  }

  Future<bool> evaluateThreshold() async {
    if (((balance / 100000000) * price) >= threshold) {
      return true;
    } else {
      return false;
    }
  }

  //handles a manual refresh initiated by the user with a pull down request
  Future<void> handleRefresh() async {
    //sync & fetch the latest balance and transaction data
    print('Pulldown Refresh Initiatied...');
    print('Getting Balance...');
    print('Getting Transactions...');
    print('Getting exchange rate');
  }

  void onPageLoad() async {
    //challenge premium status and initialize appropriate wallet
    premiumChallenge();
    bool thresholdExceeded = false;
    if (premium == false) {
      thresholdExceeded = await evaluateThreshold();
    }
    //if user is not premium and if $ value exceeds threshold and if user has not already opted out, show premium pop up
    if (premium == false && thresholdExceeded == true && optedOut == false) {
      thresholdPopUp();
    }
  }

  void thresholdPopUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ThresholdPopup(),
      ),
    );
  }

  //returns a chronologically sorted list of transaction history from the currently loaded wallet
  // Future<void> listTransactions() async {
  //   final tx = await bdk.getTransactions(wallet);
  //   //sort txs in descending order
  //   tx.sort((a, b) {
  //     //both confirmation times are null, consider them equal in terms of sorting
  //     //null here indicates that a tx is currently unconfirmed, these txs have the highest order precedence
  //     if (a.confirmationTime == null && b.confirmationTime == null) return 0;
  //     //if A's confirmation time is null and B is not, A goes first
  //     if (a.confirmationTime == null) return -1;
  //     //if B's confirmation time is null and A is not, B goes first
  //     if (b.confirmationTime == null) return 1;
  //     //if neither confirmation time is null, the value is now safe to access
  //     return b.confirmationTime!.timestamp
  //         .compareTo(a.confirmationTime!.timestamp);
  //   });
  //   transactions = tx.map((transaction) {
  //     return ExpandableTransaction(transaction: transaction);
  //   }).toList();
  // }

  //used to format a unix timestamp into either a string representing unconfirmed or a standard date time
  String formatTimestamp(int? timestamp) {
    if (timestamp == null) {
      return "Pending";
    } else {
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      var formattedDate = DateFormat('MM/dd/yyyy').format(date);
      return formattedDate;
    }
  }

  // Widget _buildTransactionCard(
  //     ExpandableTransaction expandableTransaction, int price) {
  //   final TransactionDetails transaction = expandableTransaction.transaction;

  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         expandableTransaction.isExpanded = !expandableTransaction.isExpanded;
  //       });
  //     },
  //     child: Card(
  //       color: Colors.grey[900],
  //       elevation: 3,
  //       margin: const EdgeInsets.symmetric(vertical: 8),
  //       child: Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             RichText(
  //               text: TextSpan(children: [
  //                 TextSpan(
  //                   text: formatTimestamp(
  //                       transaction.confirmationTime?.timestamp),
  //                   style: const TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 TextSpan(
  //                   text:
  //                       "  ${transaction.received - transaction.sent} sats  (\$ ${(((transaction.received - transaction.sent) / 100000000) * price).toStringAsFixed(2)} )",
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     color: (transaction.received - transaction.sent) < 0
  //                         ? Colors.red
  //                         : Colors.green,
  //                   ),
  //                 ),
  //               ]),
  //             ),
  //             const SizedBox(height: 4),
  //             if (expandableTransaction
  //                 .isExpanded) // Show details only if expanded
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'TXID: ${transaction.txid}',
  //                     style: const TextStyle(
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     'Timestamp: ${transaction.confirmationTime?.timestamp ?? "Pending"}',
  //                     style: const TextStyle(
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     'Fee: ${transaction.fee}',
  //                     style: const TextStyle(
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(_currentIndex == 0 ? 'Spending' : 'Savings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: handleRefresh,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : premium
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Premium Spending wallet will go here',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ],
                    ),
                  )
                : CustomScrollView(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        AnimatedBuilder(
                                          animation: _controller,
                                          builder: (context, child) {
                                            return Text(
                                              "\$ ${((balance / 100000000) * price).toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 48,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ),
                                        Text(
                                          "$balance Sats",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 24,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SpendingReceive(),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .orange, // Set the background color here
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 16,
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Receive',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SpendingSend(),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.orange,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 16,
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Send',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        // Expanded(
                                        //   child: ListView.builder(
                                        //     itemCount: transactions.length,
                                        //     itemBuilder: (context, index) {
                                        //       return _buildTransactionCard(
                                        //           transactions[index], price);
                                        //     },
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SavingsDashboard(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[800],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Spending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'Savings',
          ),
        ],
      ),
    );
  }
}
