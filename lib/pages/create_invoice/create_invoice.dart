// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:ezbill/common_widget/common_widget.dart';
import 'package:ezbill/common_widget/label.dart';
import 'package:ezbill/pages/create_invoice/create_invoice_components/create_invoice_components.dart';
import 'package:ezbill/pages/invoice_preview_page/invoice_preview_page.dart';
import 'package:ezbill/provider/provider.dart';
import 'package:ezbill/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../styles/fonts.dart';

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({super.key});

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  final billingPartyController = TextEditingController();
  final partyEmailController = TextEditingController();
  final partyPhoneController = TextEditingController();
  final partyLandMarkController = TextEditingController();
  final partyZipController = TextEditingController();
  final discountController = TextEditingController();
  String? cityValue;
  String? stateValue;
  String? countryValue;
  double subtotal = 0;
  String invoice_id = '';
  List contactsList = [];

  Future<void> companyList() async {
    final ref = FirebaseDatabase.instance.ref();
    final userData = await ref
        .child('users/${FirebaseAuth.instance.currentUser!.uid}/contacts')
        .get();
    final data = userData.value as Map<dynamic, dynamic>?;
    contactsList = data!.values.toList();
  }

  Future<void> createInvoice(List lineItems) async {
    try {
      final DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(FirebaseAuth.instance.currentUser!.uid);

      final DatabaseReference invoiceRef = userRef.child('invoices').push();
      final DatabaseReference billingToRef = invoiceRef.child('billingTO');
      final DatabaseReference itemRef = invoiceRef.child('lineItems');
      setState(() {
        invoice_id = invoiceRef.key.toString();
      });

      final invoiceData = {
        'invoiceNumber': 'INV 001',
        'billingCompany': billingPartyController.text,
        'email': partyEmailController.text,
        'phone': partyPhoneController.text,
        'addressline': partyLandMarkController.text,
        'country': countryValue,
        'state': stateValue,
        'city': cityValue,
        'pin': partyZipController.text,
        'sub_total': subtotal,
        'discount': discountPercentage,
        'grand_total': subtotal - discountAmount
      };
      billingToRef.set(invoiceData);

      // Add line items using unique keys
      for (int i = 0; i < lineItems.length; i++) {
        DatabaseReference lineItemRef =
            itemRef.push(); // Generate a unique key for each line item
        await lineItemRef.set(lineItems[i]);
      }
      lineItems.clear();
      setState(() {
        subtotal = 0;
      });
    } catch (e) {
      print('Error creating invoice: $e');
    }
  }

  double calculateSubtotal(List<Map<String, dynamic>> items) {
    subtotal = 0; // Reset the subtotal to zero
    for (var item in items) {
      subtotal += double.parse(item['total']);
    }
    return subtotal;
  }

  double calculateDiscountAmount(double subtotal, double discountPercentage) {
    return (subtotal * discountPercentage) / 100;
  }

  double calculateGrandTotal(double subtotal, double discountPercentage) {
    double discountAmount = (subtotal * discountPercentage) / 100;
    return subtotal - discountAmount;
  }

  double discountPercentage = 0;
  double discountAmount = 0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      stateValue = "California";
      cityValue = "Los Angeles";
    });
    companyList();
    return Consumer<InvoiceProvider>(builder: (context, invoiceProvider, _) {
      var invoiceItems =
          Provider.of<InvoiceProvider>(context, listen: false).invoiceItems;
      subtotal = calculateSubtotal(invoiceItems);
      // double discountAmount =
      //     calculateDiscountAmount(subtotal, discountPercentage);

      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'New Invoice',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: SpecialColors.appColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                const ValidationLabel(
                  label: 'BILL TO',
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Card(
                    color: Colors.white,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: billingPartyController,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    border: OutlineInputBorder()),
                              ),
                              suggestionsCallback: (pattern) async {
                                final suggestions = contactsList.where((item) {
                                  final companyName =
                                      item['company_name'] ?? '';
                                  return companyName
                                      .toLowerCase()
                                      .contains(pattern.toLowerCase());
                                }).toList();

                                return suggestions;
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(suggestion['company_name'] ?? ''),
                                  subtitle: Text(
                                      'Address: ${suggestion['address_line']}, Phone: ${suggestion['phone']}'),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                setState(() {
                                  billingPartyController.text =
                                      suggestion['company_name'];
                                  partyEmailController.text =
                                      suggestion['email'];
                                  partyPhoneController.text =
                                      suggestion['phone'];
                                  partyLandMarkController.text =
                                      suggestion['address_line'];
                                  stateValue = suggestion['state'];

                                  cityValue = suggestion['city'];
                                  print('------------------------');
                                  print(cityValue);
                                  print('------------------------');
                                  partyZipController.text = suggestion['pin'];
                                });
                              },
                            ),

                            // CustomTextField(
                            //     hintText: 'Company Name',
                            //     controller: billingPartyController,
                            //     maxlines: 1,
                            //     textType: TextInputType.text),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextField(
                                hintText: 'Email',
                                controller: partyEmailController,
                                maxlines: 1,
                                textType: TextInputType.text),
                            const SizedBox(
                              height: 15,
                            ),
                            IntlPhoneField(
                              controller: partyPhoneController,
                              validator: (val) {
                                if (val == null || val == '') {
                                  return '';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Phone Number',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(
                                      255,
                                      223,
                                      225,
                                      230,
                                    ),
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(
                                      255,
                                      223,
                                      225,
                                      230,
                                    ),
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Color.fromARGB(
                                          255,
                                          223,
                                          225,
                                          230,
                                        ))),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                              ),
                              initialCountryCode: 'IN',
                              onChanged: (phone) {},
                            ),
                            CustomTextField(
                                hintText: 'addressLine',
                                controller: partyLandMarkController,
                                maxlines: 1,
                                textType: TextInputType.text),
                            const SizedBox(
                              height: 15,
                            ),
                            CSCPicker(
                              flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                              disableCountry: true,
                              defaultCountry: CscCountry.India,
                              layout: Layout.vertical,
                              onCountryChanged: (value) {
                                setState(() {
                                  print(value);
                                  countryValue = value;
                                });
                              },
                              onStateChanged: (value) {
                                setState(() {
                                  stateValue = value;
                                });
                              },
                              onCityChanged: (value) {
                                setState(() {
                                  cityValue = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextField(
                                hintText: 'Pin Code',
                                controller: partyZipController,
                                maxlines: 1,
                                textType: TextInputType.number),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Card(
                    color: Colors.white,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: OutlinedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              vertical: 15, horizontal: 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AddItems()));
                                  },
                                  label: const Text(
                                    'Add Line Item',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: SpecialColors.appColor,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.add_business,
                                    color: SpecialColors.appColor,
                                  )),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, int index) {
                                var invoiceItems = Provider.of<InvoiceProvider>(
                                        context,
                                        listen: false)
                                    .invoiceItems;

                                var item = invoiceItems[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Item: ${item['itemName']}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    'Price: \$${item['itemPrice']}'),
                                                Text(
                                                    'Qty: ${item['itemQuantity']}'),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text('Tax: \$${item['itemTax']}'),
                                            const Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Total:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '\$${item['total']}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            const Divider(
                                                height: 1, thickness: 1),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            invoiceProvider.invoiceItems
                                                .removeAt(index);
                                          });
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: invoiceProvider.invoiceItems.length,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Subtotal:',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        '\$${subtotal.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Discount (${discountPercentage}%):',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        '- \$${(discountAmount).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: SizedBox(
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: TextField(
                                      controller: discountController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        setState(() {
                                          if (val.isNotEmpty) {
                                            discountPercentage =
                                                double.parse(val);
                                            discountAmount =
                                                calculateDiscountAmount(
                                                    subtotal,
                                                    discountPercentage);
                                          } else {
                                            discountPercentage = 0;
                                            discountAmount = 0;
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 4),
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: Colors.black,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total after Discount:',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '\$${calculateGrandTotal(subtotal, discountPercentage).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const BeveledRectangleBorder(),
                          backgroundColor: SpecialColors.specialGreenColor),
                      onPressed: () async {
                        await createInvoice(invoiceItems)
                            .then((value) => Navigator.pop(context));

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InvoicePreviewPage(
                                    invoiceKey: invoice_id)));
                      },
                      child: Text(
                        "Create",
                        style: TextFonts.secondaryText,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
