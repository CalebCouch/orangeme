class TransactionDetails {
  final bool isReceived;
  final String date;
  final String time;
  final String address;
  final double btcValueSent;
  final double? bitcoinPrice;
  final double? value;
  final double? fee;
  final String? speed;
  final String? recipient;

  const TransactionDetails(
      this.isReceived,
      this.date,
      this.time,
      this.address,
      this.btcValueSent,
      this.bitcoinPrice,
      this.value,
      this.fee,
      this.speed,
      this.recipient);
}
/*
class ReceiveTD {
  final String? recipientContact;
  final String? date;
  final String? time;
  final String sentToAddress;
  final double amountSentBTC;
  final double amountSentUSD;
  final double bitcoinPrice;
  final double fee;
  final double totalAmountSent;

  const ReceiveTD(
    this.recipientContact,
    this.date,
    this.time,
    this.sentToAddress,
    this.amountSentBTC,
    this.amountSentUSD,
    this.bitcoinPrice,
    this.fee,
    this.totalAmountSent,
  );
}

class SendTD {
  final String? recipientContact;
  final String? date;
  final String? time;
  final String sentToAddress;
  final double amountSentBTC;
  final double amountSentUSD;
  final double bitcoinPrice;
  final double fee;
  final double totalAmountSent;

  const SendTD(
    this.recipientContact,
    this.date,
    this.time,
    this.sentToAddress,
    this.amountSentBTC,
    this.amountSentUSD,
    this.bitcoinPrice,
    this.fee,
    this.totalAmountSent,
  );
}
*/