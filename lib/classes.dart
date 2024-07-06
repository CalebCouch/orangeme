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
        'receiver': this.receiver,
        'sender': this.sender,
        'txid': this.txid,
        'net': this.net,
        'fee': this.fee,
        'timestamp': this.timestamp,
        'raw': this.raw
      };
}

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
    return RustR(json['uid'] as String, json['data'] as String);
  }

  Map<String, dynamic> toJson() => {
        'uid': this.uid,
        'data': this.data,
      };
}

class CreateTransactionInput {
  final String address;
  final int sats;
  final int block_target;

  CreateTransactionInput(this.address, this.sats, this.block_target);

  Map<String, dynamic> toJson() => {
        'address': this.address,
        'sats': this.sats,
        'block_target': this.block_target,
      };
}

//Needed for WalletHome and the first screen in the send flow
class WalletBalance {
  final int satsBal;
  final double btcBal;
  final double usdBal;

  WalletBalance(this.satsBal, this.btcBal, this.usdBal);

  Map<String, dynamic> toJson() => {
        'sats': this.satsBal,
        'btc': this.btcBal,
        'usd': this.usdBal,
      };
}

//Needed for WalletHome to build the transaction history
//we need to return a list of these transaction items, sorted in ascending timestamp order with unconfirmed txs being given the highest precedence
class TransactionListItem {
  final int txIndex;
  final bool receive;
  //the timestamp should be formatted to show 12 hr time with AM/PM designator if within the last calendar day, 'Yesterday' if within the previous calendar day, 'Month day' if within the previous calendar year, or 'Month day, Year' otherwise
  final String timestamp;
  //net here should not include the tx fee and should be in USD terms
  final double grossUSDVal;

  TransactionListItem(
      this.txIndex, this.receive, this.timestamp, this.grossUSDVal);

  Map<String, dynamic> toJson() => {
        'txIndex': this.txIndex,
        'receive': this.receive,
        'timestamp': this.timestamp,
        'gross': this.grossUSDVal
      };
}

//this class should be returned when given a txIndex
class TransactionDetails {
  final int txIndex;
  final bool receive;
  final double grossUSDVal;
  final double grossBTCVal;
  //date should return MM/DD/YYYY or 'Pending' if unconfirmed
  final String date;
  //time should return in 12 hour format with AM/PM designator
  final String time;
  //receive address should be truncated in the middle
  final String receiveAddress;
  //price should be returned for the day the tx was confirmed or show the current price if unconfirmed
  final double historicalPrice;
  //fee and net should only be returned if the receive bool is false, implying that this was an outgoing tx
  final double feeUSDVal;
  final double netUSDVal;

  TransactionDetails(
      this.txIndex,
      this.receive,
      this.grossUSDVal,
      this.grossBTCVal,
      this.date,
      this.time,
      this.receiveAddress,
      this.historicalPrice,
      this.feeUSDVal,
      this.netUSDVal);

  Map<String, dynamic> toJson() => {
        'txIndex': this.txIndex,
        'receive': this.receive,
        'grossUSDVal': this.grossUSDVal,
        'grossBTCVal': this.grossBTCVal,
        'date': this.date,
        'time': this.time,
        'receiveAddress': this.receiveAddress,
        'historicalPrice': this.historicalPrice,
        'feeUSDVal': this.feeUSDVal,
        'netUSDVal': this.netUSDVal,
      };
}
