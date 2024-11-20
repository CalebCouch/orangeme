import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/list_item.dart';
// import 'package:orange/flows/messages/conversation/conversation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
//import 'package:orange/global.dart' as global;

class ChooseRecipient extends GenericWidget {
    ChooseRecipient({super.key});

    List<Profile> users = [];
    bool noUsers = true;

    @override
    ChooseRecipientState createState() => ChooseRecipientState();
}

class ChooseRecipientState extends GenericState<ChooseRecipient> {
    @override
    PageName getPageName() {
        return PageName.chooseRecipient();
    }

    @override
    int refreshInterval() {
        return 0;
    }

    @override
    void unpack_state(Map<String, dynamic> json) {
        setState(() {
            widget.users = List<Profile>.from(json['users'].map(
                (json) => Profile(
                    name: json['name'] as String,
                    did: json['did'] as String,
                    abtMe: json['about_me'] as String?,
                    pfpPath: json['pfp_path'] as String?,
                )
            ));
            widget.noUsers = widget.users.isEmpty;
        });
    }

    List<Profile> recipients = [];
    List<Profile> filteredContacts = [];
    TextEditingController searchController = TextEditingController();
    bool hasRecipients = false;

    onNext() {/*navigateTo(Exchange(Conversation(recipients, [])));*/}

    @override
    Widget build_with_state(BuildContext context) {
        return Stack_Default(
            header: Header_Button(context, "Choose recipient", CustomButton(
                txt: 'Next',
                variant: 'ghost', 
                size: 'md', 
                expand: false, 
                onTap: onNext,
                enabled: recipients.isNotEmpty,
            )),
            content: [
                Searchbar(searchController),
                recipients.isEmpty ? Container() : SelectedContacts(recipients),
                widget.noUsers ? NoUsers() : ListContacts(filteredContacts),
            ],
            bumper: Bumper(context, content: [Container()]),
        );
    }

    //The following widgets can ONLY be used in this file

    Widget SelectedContacts(recipients) {
        return Container(
            alignment: Alignment.topLeft,
            child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List<Widget>.generate(recipients.length, (index) {
                    return CustomButton(
                        txt: recipients[index].name, 
                        variant: 'secondary',
                        size: 'md',
                        expand: false,
                        icon: 'close',
                        onTap: () {removeRecipient(recipients[index]);}, 
                    );
                }),
            ),
        );
    }

    Widget ListContacts(filteredContacts) {
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredContacts.length,
            itemBuilder: (BuildContext context, int index) {
                return ContactItem(context, filteredContacts[index], () {
                    HapticFeedback.heavyImpact();
                    addRecipient(filteredContacts[index]);
                });
            },
        );
    }

    Widget NoUsers(){
        return const CustomText(
            variant: 'text',
            font_size: 'md',
            text_color: 'text_secondary', 
            txt: "There's no one here!",
        );
    }

    @override
    void initState() {
        super.initState();
        filteredContacts = widget.users;
        searchController.addListener(_filterContacts);
    }

    @override
    void dispose() {
        searchController.removeListener(_filterContacts);
        searchController.dispose();
        super.dispose();
    }

    void _filterContacts() {
        setState(() {
            String searchTerm = searchController.text.toLowerCase();
            if (searchTerm.isEmpty) {
                filteredContacts = widget.users;
            } else {
                filteredContacts = widget.users.where((contact) => contact.name.toLowerCase().startsWith(searchTerm) || contact.did.toLowerCase().startsWith(searchTerm)).toList();
            }
        });
    }

    void addRecipient(Profile selected) {
        setState(() {
            if (!recipients.contains(selected)) {
                recipients.add(selected);
            }
        });
    }

    void removeRecipient(Profile selected) {
        setState(() {
            recipients.remove(selected);
        });
    }
}

Widget Searchbar(controller) {
    return CustomTextInput(
        maxLines: 1,
        controller: controller,
        hint: 'Profile name...',
    );
}
