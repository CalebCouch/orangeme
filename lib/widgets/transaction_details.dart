import 'package:flutter/material.dart';
import 'package:orange/widgets/value_display.dart';
import 'package:orange/classes.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/styles/constants.dart';
import 'package:intl/intl.dart';

class TransactionDetails extends StatefulWidget {
  final Transaction transaction;
  final double? price;

  const TransactionDetails(
      {super.key, required this.transaction, required this.price});

  @override
  State<TransactionDetails> createState() => TransactionDetailsState();
}

class TransactionDetailsState extends State<TransactionDetails> {
  String historicalPrice = '0';

  @override
  void initState() {
    super.initState();
    getHistoricalPrice(formatTimestamp(widget.transaction.timestamp));
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatSatsToDollars(int sats, String price) {
    print("formatting sats to dollars...");
    print("sats: $sats");
    print("price within formatting sats to dollar: $price");
    double amount = (sats / 100000000) * double.parse(price);
    print("formatted amount: $amount");
    return amount.toStringAsFixed(2);
  }

  String formatTimestamp(DateTime? time) {
    if (time == null) {
      return "Pending";
    } else {
      return DateFormat('MM/dd/yyyy').format(time);
    }
  }

  String formatTime(DateTime? time) {
    if (time == null) {
      return "Pending";
    } else {
      DateTime localTime = time.toLocal();
      DateFormat timeFormat = DateFormat('hh:mm a');
      return timeFormat.format(localTime);
    }
  }

  Future<void> getHistoricalPrice(String date) async {
    if (widget.transaction.timestamp != null) {
      print('Getting Price...');
      var price = double.parse(HandleError(
          await invoke(method: "get_price", args: [date]), context));
      print("Price: ${price}");
      setState(() {
        historicalPrice = price.toStringAsFixed(2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Transaction Details Builder...");
    print("transaction net: ${widget.transaction.net}");
    String title =
        widget.transaction.net < 0 ? "Sent Bitcoin" : "Received Bitcoin";
    final displayPrice = widget.price.toString() ?? '0';
    print("display price: $displayPrice");
    String date = formatTimestamp(widget.transaction.timestamp);
    String time = formatTime(widget.transaction.timestamp);
    String sendReceiveTitle =
        widget.transaction.net < 0 ? "Sent to Address" : "Received to Address";
    print("Receiver: ${widget.transaction.sender}");
    print("Sender: ${widget.transaction.receiver}");
    String address = widget.transaction.net < 0
        ? (widget.transaction.sender ?? "null")
        : (widget.transaction.receiver ?? "null");
    String amountSendReceiveTitle =
        widget.transaction.net < 0 ? "Amount Sent" : "Amount Received";
    String valueTitle =
        widget.transaction.net < 0 ? "USD Value Sent" : "USD Value Received";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          ValueDisplay(
            fiatAmount:
                formatSatsToDollars(widget.transaction.net, displayPrice),
            quantity: (widget.transaction.net / 100000000).toStringAsFixed(8),
          ),
          Expanded(
            child: ListView(
              children: [
                DetailRow(label: "Date", value: date),
                DetailRow(label: "Time", value: time),
                DetailRow(label: sendReceiveTitle, value: address),
                DetailRow(
                    label: amountSendReceiveTitle,
                    value: "${widget.transaction.net} sats"),
                DetailRow(
                    label: "Bitcoin Price",
                    value: widget.transaction.timestamp != null
                        ? "\$$historicalPrice"
                        : "\$${widget.price.toString()}"),
                DetailRow(
                    label: valueTitle,
                    value: widget.transaction.timestamp != null
                        ? "\$${formatSatsToDollars(widget.transaction.net, historicalPrice)}"
                        : "\$${formatSatsToDollars(widget.transaction.net, displayPrice)}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.textSM
                  .copyWith(color: AppColors.textSecondary)),
          Text(value,
              style: AppTextStyles.textSM
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
