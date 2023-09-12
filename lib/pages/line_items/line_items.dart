import 'package:ezbill/pages/contacts/contacts_components/contacts_components.dart';
import 'package:ezbill/styles/colors.dart';
import 'package:ezbill/styles/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LineItems extends StatefulWidget {
  const LineItems({super.key});

  @override
  State<LineItems> createState() => _LineItemsState();
}

class _LineItemsState extends State<LineItems> {
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: SpecialColors.appColor,
        title: Text(
          'Items',
          style: TextFonts.normalwhiteText,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Create Product',
                          style: TextFonts.secondaryText,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        CustomTextField(
                            hintText: 'Product Name',
                            prefixIcon: const Icon(Icons.add_box),
                            textInputType: TextInputType.text,
                            controller: productNameController),
                        const SizedBox(
                          height: 25,
                        ),
                        CustomTextField(
                            hintText: "Product price",
                            prefixIcon: const Icon(Icons.price_change_rounded),
                            textInputType: TextInputType.number,
                            controller: productPriceController),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: FilledButton(
                            child: const Text('Create Item'),
                            onPressed: () {
                              //Navigator.pop(context);
                              //   FirebaseDatabase.instance.ref().child('users/${FirebaseAuth.instance.currentUser!.uid}/')
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
