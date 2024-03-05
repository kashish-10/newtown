import 'package:contacts_service/contacts_service.dart';
import 'package:diva/db/db_services.dart';
import 'package:diva/model/contacts_model.dart';
import 'package:diva/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  final List<Contact> _userSelectedContacts = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  TextEditingController searchController = TextEditingController();

  // const String contactTable ;
  @override
  void initState() {
    super.initState();
    askPermission();
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  filterContacts() {
    List<Contact> filteredList =
        List<Contact>.from(contacts); // Create a new list

    if (searchController.text.isNotEmpty) {
      String searchterm = searchController.text.toLowerCase();
      String searchtermFlatten = flattenPhoneNumber(searchterm);

      filteredList.retainWhere((element) {
        String? contactName = element.displayName?.toLowerCase();
        bool nameMatch = contactName?.contains(searchterm) ?? false;

        if (nameMatch) return true;

        if (searchtermFlatten.isEmpty) return false;

        var phone = element.phones!.firstWhere((p) {
          String phnFlattened = flattenPhoneNumber(p.value!);
          return phnFlattened.contains(searchtermFlatten);
        });

        return phone != null;
      });
    }

    setState(() {
      contactsFiltered = filteredList;
    });
  }

  Future<void> askPermission() async {
    PermissionStatus permissionStatus = await getContactsPermissions();

    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    } else {
      handleInvalidPermissions(permissionStatus);
    }
  }

  handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      dialogueBox(context, "Access denied by user");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      dialogueBox(context, "Contacts doesn't exist");
    }
  }

  Future<PermissionStatus> getContactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<void> getAllContacts() async {
    print("Fetching contacts...");
    List<Contact> fetchedContacts =
        await ContactsService.getContacts(withThumbnails: false);
    print("Fetched ${fetchedContacts.length} contacts");

    setState(() {
      contacts = fetchedContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemExist = (contactsFiltered.isNotEmpty || contacts.isNotEmpty);
    return Scaffold(
      body: contacts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      autofocus: true,
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: "Search Contact",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  listItemExist == true
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: isSearching == true
                                ? contactsFiltered.length
                                : contacts.length,
                            itemBuilder: (BuildContext context, int index) {
                              Contact contact = isSearching == true
                                  ? contactsFiltered[index]
                                  : contacts[index];
                              var displayName = contact.displayName ?? '';
                              var len = displayName.length ??
                                  0; // Using the provided method
                              return ListTile(
                                title: Text(len != 0 ? displayName : 'No Name'),
                                leading: contact.avatar != null &&
                                        contact.avatar!.isNotEmpty
                                    ? CircleAvatar(
                                        backgroundImage:
                                            MemoryImage(contact.avatar!),
                                      )
                                    : CircleAvatar(
                                        child: Text(contact.initials()),
                                      ),
                                onTap: () {
                                  if (contact.phones!.isNotEmpty) {
                                    final String phoneNum =
                                        contact.phones!.elementAt(0).value!;
                                    final String name = contact.displayName!;
                                    _addContact(TContact(phoneNum, name));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Phone no. of this contact does not exist');
                                  }
                                },
                              );
                            },
                          ),
                        )
                      : Container(
                          child: const Text("Searching"),
                        )
                ],
              ),
            ),
    );
  }

  void _addContact(TContact newContact) async {
    bool contactExists = await _contactExists(newContact);

    if (!contactExists) {
      int? result = await _databaseHelper.insertContact(newContact);
      if (result != null && result > 0) {
        Fluttertoast.showToast(msg: 'Contact added successfully');
      } else {
        Fluttertoast.showToast(msg: 'Failed to add contact');
      }
    } else {
      Fluttertoast.showToast(msg: 'Contact already exists');
    }

    Navigator.of(context).pop(true);
  }

  Future<bool> _contactExists(TContact contact) async {
    Database? db = await _databaseHelper.database;

    var existingContacts = await db?.query(
      DatabaseHelper.contactTable,
      where:
          '${DatabaseHelper.colContactNumber} = ? AND ${DatabaseHelper.colContactName} = ?',
      whereArgs: [contact.number, contact.name],
    );

    return existingContacts != null && existingContacts.isNotEmpty;
  }
}
