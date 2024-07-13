//Internal
class DartCommand {
  final String method;
  final String data;

  DartCommand(this.method, this.data);

  factory DartCommand.fromJson(Map<String, dynamic> json) {
    return DartCommand(json['method'] as String, json['data'] as String);
  }
}

class RustC {
  final String uid;
  final String method;
  final String data;

  RustC(this.uid, this.method, this.data);

  factory RustC.fromJson(Map<String, dynamic> json) {
    return RustC(json['uid'] as String, json['method'] as String,
        json['data'] as String);
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'method': method,
        'data': data,
      };
}

class RustR {
  final String uid;
  final String data;

  RustR(this.uid, this.data);

  factory RustR.fromJson(Map<String, dynamic> json) {
    return RustR(json['uid'] as String, json['data'] as String);
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'data': data,
      };
}
//Internal

//Transfer
class Balance {
  final double usd;
  final double btc;

  Balance(this.usd, this.btc);

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
        json['usd'] as double,
        json['btc'] as double
    );
  }
}

class HomeTx {
  final String txid;
  final bool is_receive;
  final String? date;
  final int amount;

  HomeTx(this.txid, this.is_receive, this.date, this.amount);

  factory HomeTx.fromJson(Map<String, dynamic> json) {
    return HomeTx(
        json['txid'] as String,
        json['is_receive'] as bool,
        json['date'] as String?,
        json['amount'] as int
    );
  }
}

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

  Map<String, dynamic> toJson() => {
        'receiver': receiver,
        'sender': sender,
        'txid': txid,
        'net': net,
        'fee': fee,
        'timestamp': timestamp,
        'raw': raw
      };
}

class CreateTransactionInput {
  final String address;
  final int sats;
  final int block_target;

  CreateTransactionInput(this.address, this.sats, this.block_target);

  Map<String, dynamic> toJson() => {
        'address': address,
        'sats': sats,
        'block_target': block_target,
      };
}
//Transfer
