import 'package:ezbill/styles/colors.dart';
import 'package:ezbill/styles/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'contacts_components/contacts_components.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: SpecialColors.appColor,
          title: Text(
            'Contacts',
            style: TextFonts.normalwhiteText,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const AddContact()));
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance
              .ref()
              .child('users/${FirebaseAuth.instance.currentUser!.uid}/contacts')
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While data is loading, display a loading indicator
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // Handle the error case
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData ||
                snapshot.data!.snapshot.value == null) {
              // If there's no data or data is null, display a message
              return const Center(
                child: Text("No contacts available"),
              );
            } else {
              // Data is available, proceed to build the ListView
              final data =
                  snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              List valuesList = data.values.toList();
              List itemKey = data.keys.toList();

              return ListView.separated(
                itemCount: valuesList.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, int index) {
                  return Dismissible(
                    onDismissed: (direction) {
                      // Show a confirmation dialog before dismissing
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text(
                                "Are you sure you want to dismiss this item?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  // Dismiss the dialog without removing the item
                                  setState(() {
                                    valuesList.insert(index, valuesList[index]);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text("Dismiss"),
                                onPressed: () {
                                  // Get the key of the item to delete

                                  // Remove the item from the database
                                  FirebaseDatabase.instance
                                      .ref()
                                      .child(
                                          'users/${FirebaseAuth.instance.currentUser!.uid}/contacts')
                                      .child(itemKey[index])
                                      .remove()
                                      .then((_) {
                                    // Remove the item from the local list and rebuild the widget

                                    // Show a snackbar
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          '${valuesList[index]['company_name']} dismissed'),
                                    ));

                                    // Dismiss the dialog
                                    Navigator.of(context).pop();
                                  }).catchError((error) {
                                    print("Error deleting item: $error");
                                    // Handle the error, show an error message, etc.
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    key: Key(valuesList[index].toString()),
                    child: Column(
                      children: [
                        ListTile(
                          leading: ClipOval(
                            child: CircleAvatar(
                              child: Text(valuesList[index]['company_name'][0]),
                            ),
                          ),
                          title: Text(valuesList[index]['company_name']),
                          subtitle: Text(
                            valuesList[index]['state'],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
