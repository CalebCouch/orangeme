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

class DartCommand {
  final String method;
  final String data;

  DartCommand(this.method, this.data);

  factory DartCommand.fromJson(Map<String, dynamic> json) {
    return DartCommand(
        json['method'] as String,
        json['data'] as String
    );
  }
}

class RustC {
  final String uid;
  final String method;
  final String data;

  RustC(this.uid, this.method, this.data);

  factory RustC.fromJson(Map<String, dynamic> json) {
    return RustC(
        json['uid'] as String,
        json['method'] as String,
        json['data'] as String
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': this.uid,
    'method': this.method,
    'data': this.data,
  };
}

class RustR {
  final String uid;
  final String data;

  RustR(this.uid, this.data);

  factory RustR.fromJson(Map<String, dynamic> json) {
    return RustR(
        json['uid'] as String,
        json['data'] as String
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': this.uid,
    'data': this.data,
  };

}

class CreateTransactionInput {
  final String address;
  final String sats;

  CreateTransactionInput(this.address, this.sats);

  Map<String, dynamic> toJson() => {
    'address': this.address,
    'sats': this.sats,
  };

}