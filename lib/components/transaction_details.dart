import 'package:flutter/material.dart';
import 'package:orange/components/value_display.dart';
import 'package:orange/classes.dart';
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
  String formatSatsToDollars(int sats, String price, bool absolute) {
    print("formatting sats to dollars...");
    print("sats: $sats");
    print("price within formatting sats to dollar: $price");
    if (absolute == true) {
      double amount = (sats.abs() / 100000000) * double.parse(price);
      print("formatted amount: $amount");
      return amount.toStringAsFixed(2);
    } else {
      double amount = (sats / 100000000) * double.parse(price);
      print("formatted amount: $amount");
      return amount.toStringAsFixed(2);
    }
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
        historicalPrice = widget.price!.toStringAsFixed(2);
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
    print("transaction fee: ${widget.transaction.fee}");
    print("transaction: ${widget.transaction}");
    print("transaction net: ${widget.transaction.net}");
    String displayPrice = widget.price!.toStringAsFixed(2);
    print("display price: $displayPrice");
    //logic used to evaluate the format of the transaction details widget based on send or receive tx
    bool send = widget.transaction.net < 0;
    //calculate the fees in dollar terms
    String feeAmount = '0';
    if (send == true) {
      print("This is a send transaction");
      print("Historical price: $historicalPrice");
      if (widget.transaction.timestamp != null) {
        feeAmount = formatSatsToDollars(
            widget.transaction.fee!, historicalPrice, false);
        print("Fee Amount: $feeAmount");
      } else {
        feeAmount =
            formatSatsToDollars(widget.transaction.fee!, displayPrice, false);
        print("Fee Amount: $feeAmount");
      }
    } else {
      print("this is a receive transaction");
    }
    //format the header title
    String title =
        widget.transaction.net < 0 ? "Sent Bitcoin" : "Received Bitcoin";
    //format the date display
    String date = formatTimestamp(widget.transaction.timestamp, false);
    //format the time display
    String time = formatTime(widget.transaction.timestamp);
    //format the sent to or received from title
    String sendReceiveTitle =
        widget.transaction.net < 0 ? "Sent to Address" : "Received to Address";
    print("Receiver: ${widget.transaction.sender}");
    print("Sender: ${widget.transaction.receiver}");
    //obtain the address
    String address = widget.transaction.net < 0
        ? (widget.transaction.sender ?? "null")
        : (widget.transaction.receiver ?? "null");
    //format the amount title
    String amountSendReceiveTitle =
        widget.transaction.net < 0 ? "Amount Sent" : "Amount Received";
    String valueTitle =
        widget.transaction.net < 0 ? "USD Value Sent" : "USD Value Received";
    //calcuate total
    String totalAmount = widget.transaction.timestamp != null
        ? formatSatsToDollars(widget.transaction.net, historicalPrice, true)
        : formatSatsToDollars(widget.transaction.net, displayPrice, true);
    String totalDisplay = widget.transaction.timestamp != null
        ? formatSatsToDollars(widget.transaction.net, historicalPrice, false)
        : formatSatsToDollars(widget.transaction.net, displayPrice, false);

    String amountSentReceived =
        (widget.transaction.net / 100000000).toStringAsFixed(8);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          ValueDisplay(
            fiatAmount: totalDisplay,
            quantity: (widget.transaction.net / 100000000).toStringAsFixed(8),
          ),
          Expanded(
            child: ListView(
              children: [
                Tabular(label: "Date", value: date),
                Tabular(label: "Time", value: time),
                Tabular(label: sendReceiveTitle, value: address),
                Tabular(
                    label: amountSendReceiveTitle,
                    value: "$amountSentReceived BTC"),
                Tabular(
                    label: "Bitcoin Price",
                    value: widget.transaction.timestamp != null
                        ? "\$$historicalPrice"
                        : "\$$displayPrice"),
                Tabular(
                    label: valueTitle,
                    value: widget.transaction.timestamp != null && send == true
                        ? "-\$${formatSatsToDollars((widget.transaction.net + widget.transaction.fee!), historicalPrice, true)}"
                        : widget.transaction.timestamp != null && send == false
                            ? "\$${formatSatsToDollars(widget.transaction.net, historicalPrice, false)}"
                            : send == true
                                ? "-\$${formatSatsToDollars((widget.transaction.net + widget.transaction.fee!), displayPrice, true)}"
                                : "\$${formatSatsToDollars(widget.transaction.net, displayPrice, false)}"),
                if (send) const SizedBox(height: 15),
                if (send) Tabular(label: "Fee Amount", value: "-\$$feeAmount"),
                if (send)
                  Tabular(
                    label: "Total Amount",
                    value: send == true ? "-\$$totalAmount" : "\$$totalAmount",
                  ),
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

class Tabular extends StatelessWidget {
  final String label;
  final String value;

  const Tabular({super.key, required this.label, required this.value});

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
