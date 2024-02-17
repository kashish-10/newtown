import 'package:diva/db/db_services.dart';
import 'package:diva/model/contacts_model.dart';
import 'package:diva/screens/contacts_screen.dart';
import 'package:diva/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({super.key});

  @override
  State<AddContacts> createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<TContact>? contactList;
  int count = 0;

  void showList() {
    Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TContact>> contactListFuture =
          databaseHelper.getContactList();
      contactListFuture.then((value) {
        setState(() {
          contactList = value;
          count = value.length;
        });
      });
      return null;
    });
  }

  void deleteContact(TContact contact) async {
    int? result = await databaseHelper.deleteContact(contact.id);
    if (result != 0) {
      Fluttertoast.showToast(msg: 'Contact removed succesfully');
      showList();
    }
  }

  void addContactIfNotExists(TContact newContact) async {
    bool contactExists = false;
    if (contactList != null) {
      for (var contact in contactList!) {
        if (contact.name == newContact.name &&
            contact.number == newContact.number) {
          contactExists = true;
          break;
        }
      }
    }

    if (!contactExists) {
      await databaseHelper.insertContact(newContact);
      Fluttertoast.showToast(msg: 'Contact added successfully');
      showList();
    } else {
      Fluttertoast.showToast(msg: 'Contact already exists');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showList();
    });
    showList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    contactList ??= [];
    return SafeArea(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: 400, // Set the desired width here
                height: 40,
                child: CustomButton(
                  onPressed: () async {
                    // Use async/await to get the result from the pushed route
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactsPage(),
                      ),
                    );

                    // Check if the result is not null and is of type bool
                    if (result != null && result is bool && result == true) {
                      showList();
                    }
                  },
                  text: "Add Emergency Contacts",
                ),
              ),
              Expanded(
                child: ListView.builder(
                  // shrinkWrap: true,
                  itemCount: count,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(contactList![index].name),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await FlutterPhoneDirectCaller.callNumber(
                                      contactList![index].number);
                                },
                                icon: const Icon(
                                  Icons.call,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  deleteContact(contactList![index]);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
