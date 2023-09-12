import 'package:ezbill/pages/pdf_view/pdf_view.dart';
import 'package:ezbill/styles/colors.dart';
import 'package:ezbill/styles/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class InvoicePreviewPage extends StatefulWidget {
  const InvoicePreviewPage({super.key, required this.invoiceKey});
  final invoiceKey;
  @override
  State<InvoicePreviewPage> createState() => _InvoicePreviewPageState();
}

class _InvoicePreviewPageState extends State<InvoicePreviewPage> {
  var data;
  var uderData1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userDetails();
  }

  Future<void> userDetails() async {
    final ref = FirebaseDatabase.instance.ref();
    final userData = await ref
        .child('users/${FirebaseAuth.instance.currentUser!.uid}/user_details')
        .get();

    print('---------------------------');

    final snapshot = await ref
        .child(
            'users/${FirebaseAuth.instance.currentUser!.uid}/invoices/${widget.invoiceKey}')
        .get();
    if (snapshot.exists) {
      setState(() {
        data = snapshot.value;
        uderData1 = userData.value;
      });
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    userDetails();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Preview'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SpecialColors.specialGreenColor,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfView(
                        invoiceKey: widget.invoiceKey,
                      )));
        },
        child: const Icon(
          Icons.picture_as_pdf,
          color: SpecialColors.appColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${uderData1['company_name']}\n${uderData1['addressline'] ?? ''}\n${uderData1['city']} - ${uderData1['pin']} \n${uderData1['state']}\n ${uderData1['country']}\n\n${uderData1['phone']}\n${uderData1['email']}\n${uderData1['gst']}',
                    style: PdfFonts.secondaryFont,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'INVOICE',
                        style: PdfFonts.primaryFont,
                      ),
                      Text(
                        data["billingTO"]["invoiceNumber"],
                        style: PdfFonts.ternaryFont,
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bill To',
                        style: PdfFonts.ternaryFont,
                      ),
                      Text(
                        '${data["billingTO"]["billingCompany"]} \n${data["billingTO"]["addressline"]} \n ${data["billingTO"]["city"]} - ${data["billingTO"]["pin"]}  \n ${data["billingTO"]["state"]}\n${data["billingTO"]["country"]} \n\n${data["billingTO"]["phone"]} \n${data["billingTO"]["email"]}\nGSTIN 29GGGGG1314R9Z6',
                        style: PdfFonts.secondaryFont,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Invoive Date',
                            style: PdfFonts.secondaryFont,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              ':',
                              style: PdfFonts.secondaryFont,
                            ),
                          ),
                          Text(
                            '10/08/2023',
                            style: PdfFonts.secondaryFont,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Mode of Payment',
                            style: PdfFonts.secondaryFont,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              ':',
                              style: PdfFonts.secondaryFont,
                            ),
                          ),
                          Text(
                            '10/08/2023',
                            style: PdfFonts.secondaryFont,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 32,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Qty',
                              style: PdfFonts.secTittle,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3, // Adjust the flex values as needed
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Product name',
                              style: PdfFonts.secTittle,
                              overflow:
                                  TextOverflow.ellipsis, // To handle long text
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Price',
                              style: PdfFonts.secTittle,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Qty',
                              style: PdfFonts.secTittle,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Total',
                              style: PdfFonts.secTittle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final lineItemId = data["lineItems"].keys.elementAt(index);
                  final lineItemData = data["lineItems"][lineItemId];
                  final itemName = lineItemData["itemName"];
                  final total = lineItemData["total"];
                  final itemQuantity = lineItemData["itemQuantity"];
                  final itemPrice = lineItemData["itemPrice"];
                  // final itemTax = lineItemData["itemTax"];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              ' ${index + 1}',
                              style: PdfFonts.secondaryFont,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3, // Adjust the flex values as needed
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              itemName,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  PdfFonts.secondaryFont, // To handle long text
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              itemPrice,
                              style: PdfFonts.secondaryFont,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              itemQuantity,
                              style: PdfFonts.secondaryFont,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              total,
                              style: PdfFonts.secondaryFont,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: data["lineItems"].length,
              ),
              const Divider(),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Align items to the right
                        children: [
                          Text(
                            'SUB TOTAL',
                            style: PdfFonts.secondaryFont,
                          ),
                          Text(
                            '\$${data["billingTO"]["sub_total"]}',
                            style: PdfFonts.secondaryFont,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Align items to the right
                        children: [
                          Text(
                            'DISCOUNT',
                            style: PdfFonts.secondaryFont,
                          ),
                          Text(
                            '${data["billingTO"]["discount"]}%',
                            style: PdfFonts.secondaryFont,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Align items to the right
                        children: [
                          Text(
                            'TOTAL',
                            style: PdfFonts.ternaryFont,
                          ),
                          Text(
                            '\$${data["billingTO"]["grand_total"]}',
                            style: PdfFonts.ternaryFont,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                'Thanks for your bussiness',
                style: PdfFonts.secondaryFont,
              )
            ],
          ),
        ),
      ),
    );
  }
}
