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
