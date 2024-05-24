import 'package:flutter/material.dart';
import 'package:orange/widgets/value_display.dart';
import 'package:orange/classes.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/styles/constants.dart';
import 'package:intl/intl.dart';
import 'package:orange/components/buttons/secondary_lg.dart';

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
    getHistoricalPrice(formatTimestamp(widget.transaction.timestamp, true));
  }

  @override
  void dispose() {
    super.dispose();
  }

  //formats a provided number of satoshis into dollars at the current price
  String formatSatsToDollars(int sats, String price) {
    print("formatting sats to dollars...");
    print("sats: $sats");
    print("price within formatting sats to dollar: $price");
    double amount = (sats / 100000000) * double.parse(price);
    print("formatted amount: $amount");
    return amount.toStringAsFixed(2);
  }

  //formats a unix time stamps into the necessary date format for either spot API or widget display
  String formatTimestamp(DateTime? time, bool api) {
    if (time == null) {
      return "Pending";
    } else if (api == false) {
      return DateFormat('MM/dd/yyyy').format(time);
    } else {
      return DateFormat('yyyy/MM/dd').format(time);
    }
  }

  //formats a unix time stamps into the local time
  String formatTime(DateTime? time) {
    if (time == null) {
      return "Pending";
    } else {
      DateTime localTime = time.toLocal();
      DateFormat timeFormat = DateFormat('hh:mm a');
      return timeFormat.format(localTime);
    }
  }

  //used to retrieve the historical spot price from the date of transaction confirmation
  //Currently broken
  Future<void> getHistoricalPrice(String date) async {
    if (widget.transaction.timestamp != null) {
      print('Getting Price...');
      // var price = double.parse(handleError(
      //     // await invoke(method: "get_historical_price", args: [date]), context));
      //     await invoke(method: "get_price")
      print("Price: ${widget.price}");
      setState(() {
        if (widget.price != null) {
          historicalPrice = widget.price.toString();
        }
      });
    }
  }

  //navigate out of the detailed transaction popup (returns to dashboard)
  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print("Transaction Details Builder...");
    print("transaction net: ${widget.transaction.net}");
    //logic used to evaluate the format of the transaction details widget based on send or receive tx
    String title =
        widget.transaction.net < 0 ? "Sent Bitcoin" : "Received Bitcoin";
    final displayPrice = widget.price.toString();
    print("display price: $displayPrice");
    String date = formatTimestamp(widget.transaction.timestamp, false);
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ButtonSecondaryLG(
              label: "Done",
              onTap: () => goBack(context),
            ),
          )
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
