import 'package:orange/classes.dart';

class Wallet {
  final String name;
  final List<Transaction> transactions;
  final double balance;
  final double btc;
  final bool isSpending;

  const Wallet(
    this.name,
    this.transactions,
    this.balance,
    this.btc,
    this.isSpending,
  );
}
