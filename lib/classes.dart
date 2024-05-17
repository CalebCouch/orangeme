class Transaction {
  final String? receiver;
  final String? sender;
  final String txid;
  final int net;
  final int? fee;
  final DateTime? timestamp;
  final String? raw;

  Transaction(this.receiver, this.sender, this.txid, this.net, this.fee,
      this.timestamp, this.raw);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    var time = json['timestamp'] as int?;
    print("Timestamp: $time");
    return Transaction(
        json['receiver'] as String?,
        json['sender'] as String?,
        json['txid'] as String,
        json['net'] as int,
        json['fee'] as int?,
        time != null ? DateTime.fromMillisecondsSinceEpoch(time * 1000) : null,
        json['raw'] as String?);
  }
}
