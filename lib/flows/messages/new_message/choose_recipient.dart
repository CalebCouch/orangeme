// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:orange/components/list_item.dart';
// import 'package:orange/classes.dart';
// // import 'package:orange/flows/messages/conversation/exchange.dart';
// import 'package:orangeme_material/orangeme_material.dart';
// import 'package:orange/src/rust/api/pub_structs.dart';
// //import 'package:orange/global.dart' as global;

// class ChooseRecipient extends GenericWidget {
//   ChooseRecipient({super.key});

//   List<Profile> users = []; //list of all orangeme users

//   @override
//   ChooseRecipientState createState() => ChooseRecipientState();
// }

// class ChooseRecipientState extends GenericState<ChooseRecipient> {
//   bool noUsers = true;
//   @override
//   PageName getPageName() {
//     return PageName.chooseRecipient;
//   }

//   @override
//   int refreshInterval() {
//     return 0;
//   }

//   @override
//   void unpack_state(Map<String, dynamic> json) {
//     setState(() {
//       widget.users = List<Profile>.from(json['users'].map((json) => Profile.fromJson(json)));
//       if (widget.users.isNotEmpty) noUsers = false;
//     });
//   }

//   List<Profile> recipients = [];
//   List<Profile> filteredContacts = [];
//   TextEditingController searchController = TextEditingController();
//   String enabled = 'enabled';

//   void checkList() {
//     setState(() {
//       enabled = recipients.isEmpty ? 'disabled' : 'enabled';
//     });
//   }

//   @override
//   Widget build_with_state(BuildContext context) {
//     checkList();
//     return Stack_Default(
//       Header_Button(context, "Choose recipient", CustomButton('Next', 'ghost md hug none', onNext, enabled)),
//       [
//         Searchbar(searchController),
//         recipients.isEmpty ? Container() : SelectedContacts(recipients),
//         noUsers ? const CustomText('text md text_secondary', "There's no one here!") : ListContacts(filteredContacts),
//       ],
//       Bumper(context, [Container()]),
//     );
//   }

//   //The following widgets can ONLY be used in this file

//   Widget SelectedContacts(recipients) {
//     return Container(
//       alignment: Alignment.topLeft,
//       child: Wrap(
//         spacing: 8,
//         runSpacing: 8,
//         children: List<Widget>.generate(recipients.length, (index) {
//           return CustomButton(recipients[index].name, 'secondary md hug close', () {
//             removeRecipient(recipients[index]);
//           }, 'enabled');
//         }),
//       ),
//     );
//   }

//   Widget ListContacts(filteredContacts) {
//     return ListView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: filteredContacts.length,
//       itemBuilder: (BuildContext context, int index) {
//         return ContactItem(context, filteredContacts[index], () {
//           HapticFeedback.heavyImpact();
//           addRecipient(filteredContacts[index]);
//         });
//       },
//     );
//   }

//   onNext() {
//     //navigateTo(Exchange(Conversation(recipients, [])));
//   }

//   @override
//   void initState() {
//     super.initState();
//     filteredContacts = widget.users;
//     searchController.addListener(_filterContacts);
//   }

//   @override
//   void dispose() {
//     searchController.removeListener(_filterContacts);
//     searchController.dispose();
//     super.dispose();
//   }

//   void _filterContacts() {
//     setState(() {
//       String searchTerm = searchController.text.toLowerCase();
//       if (searchTerm.isEmpty) {
//         filteredContacts = widget.users;
//       } else {
//         filteredContacts = widget.users.where((contact) => contact.name.toLowerCase().startsWith(searchTerm) || contact.did.toLowerCase().startsWith(searchTerm)).toList();
//       }
//     });
//   }

//   void addRecipient(Profile selected) {
//     setState(() {
//       if (!recipients.contains(selected)) {
//         recipients.add(selected);
//       }
//     });
//   }

//   void removeRecipient(Profile selected) {
//     setState(() {
//       recipients.remove(selected);
//     });
//   }
// }

// Widget Searchbar(controller) {
//   return CustomTextInput(
//     maxLines: 1,
//     controller: controller,
//     hint: 'Search by profile name or DID...',
//   );
// }
