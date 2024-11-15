import 'package:flutter/material.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';


///////////////////////////////////////////////////

// FIX THIS AFTER TRANSACTION TYPES ARE DEFINED //

///////////////////////////////////////////////////

//import 'package:orange/global.dart' as global;

// class ViewTransaction extends GenericWidget {
//     String txid;
//     ViewTransaction({super.key, required this.txid});

//     late BasicTransaction? basic_transaction;
//     late ExtTransaction? ext_transaction;

//     @override
//     ViewTransactionState createState() => ViewTransactionState();
// }

// class ViewTransactionState extends GenericState<ViewTransaction> {
//     @override
//     PageName getPageName() {
//         return PageName.viewTransaction(widget.txid);
//     }

//     @override
//     int refreshInterval() {
//         return 1;
//     }

//     @override
//     String options() {
//         return widget.txid;
//     }

//     @override
//     void unpack_state(Map<String, dynamic> json) {
//         setState(() {
//             widget.basic_transaction = json['basic_transaction'] != null ? BasicTransaction.fromJson(json['basic_transaction']) : null;
//             widget.ext_transaction = json['ext_transaction'] != null ? ExtTransaction.fromJson(json['ext_transaction']) : null;
//         });
//     }

//     onDone() {
//         Navigator.pop(context);
//     }

//     getBalance(received, sent){
//         if(received != null) {
//             return ("Received bitcoin", received.);
//         }
//         if(sent != null) {
//             return ();
//         }
//         // throw error
//         return ();
//     }

//     Widget build_with_state(BuildContext context) {
//         String header_text = "Invalid Transaction Type"
//         if (widget.received_transaction != null) String header_text = "Received Bitcoin";
//         if (widget.sent_transaciton != null) String header_text = "Sent Bitcoin";

//         return Stack_Default(
//             header: Header_Stack(context, header_text),
//             content: [
//                 BalanceDisplay(tx),
//                 if (direction == 'Received') transactionTabular(context, widget.ext_transaction!),
//                 if (direction == 'Sent') sendTransactionTabular(context, widget.ext_transaction!),
//             ],
//             Bumper(context, [CustomButton('Done', 'secondary lg expand none', () => onDone(), true)]),
//         );
//     }
//   //The following widgets can ONLY be used in this file

//   Widget BalanceDisplay(BasicTransaction tx) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: CustomText('heading title', tx.tx.usd),
//           ),
//           const Spacing(8),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [CustomText('text lg text_secondary', '${tx.tx.btc} BTC')],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
