import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfView extends StatefulWidget {
  const PdfView({Key? key, required this.invoiceKey}) : super(key: key);
  final invoiceKey;
  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
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
  // Future<void> savePdfToFile() async {
  //   Directory? dir;
  //   final pdf = await makePdf();
  //   dir = Directory('/storage/emulated/0/Download');
  //   final file = File("${dir.path}/example.pdf");
  //   await file.writeAsBytes(pdf);
  //   // await DownloadNotification().showProgressNotification(file.path);
  //   print("PDF saved to: ${file.path}");
  // }

  Future<Uint8List> makePdf() async {
    final ttfFont = await PdfGoogleFonts.robotoBold();
    final normalFont = await PdfGoogleFonts.robotoMedium();
    final pdf = pw.Document();
    // var netImage = await networkImage(
    //     "https://images.pexels.com/photos/213780/pexels-photo-213780.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500");
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'INVOICE',
                  style: pw.TextStyle(
                    font: ttfFont,
                    fontSize: 45,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(
                        const Color.fromRGBO(78, 138, 110, 1).value),
                  ),
                ),
                pw.SizedBox(
                  height: 35,
                ),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'N.INVOICE',
                                    style: pw.TextStyle(
                                      font: normalFont,
                                      fontSize: 10,
                                      color: PdfColor.fromInt(
                                          const Color.fromRGBO(76, 75, 75, 1)
                                              .value),
                                    ),
                                  ),
                                  pw.Text(
                                    'EB1134',
                                    style: pw.TextStyle(
                                      font: ttfFont,
                                      fontSize: 10,
                                      color:
                                          PdfColor.fromInt(Colors.black.value),
                                    ),
                                  ),
                                ]),
                            pw.SizedBox(
                              height: 7,
                            ),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'DATE',
                                    style: pw.TextStyle(
                                      font: normalFont,
                                      fontSize: 10,
                                      color: PdfColor.fromInt(
                                          const Color.fromRGBO(76, 75, 75, 1)
                                              .value),
                                    ),
                                  ),
                                  pw.Text(
                                    '25 SEB 2023',
                                    style: pw.TextStyle(
                                      font: ttfFont,
                                      fontSize: 10,
                                      color:
                                          PdfColor.fromInt(Colors.black.value),
                                    ),
                                  ),
                                ]),
                            pw.SizedBox(
                              height: 7,
                            ),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'PAYMENT METHOD',
                                    style: pw.TextStyle(
                                      font: normalFont,
                                      fontSize: 10,
                                      color: PdfColor.fromInt(
                                          const Color.fromRGBO(76, 75, 75, 1)
                                              .value),
                                    ),
                                  ),
                                  pw.Text(
                                    'CREDIT CARD',
                                    style: pw.TextStyle(
                                      font: ttfFont,
                                      fontSize: 10,
                                      color:
                                          PdfColor.fromInt(Colors.black.value),
                                    ),
                                  ),
                                ]),
                          ]),
                      pw.Container(
                        width: 2,
                        height: 65,
                        color: PdfColor.fromInt(
                            const Color.fromRGBO(76, 75, 75, 1).value),
                      ),
                      pw.Row(children: [
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      '${uderData1['company_name']}',
                                      style: pw.TextStyle(
                                        font: normalFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            const Color.fromRGBO(76, 75, 75, 1)
                                                .value),
                                      ),
                                    ),
                                    pw.Text(
                                      '${uderData1['addressline'] ?? ''} \n ${uderData1['city']} - ${uderData1['pin']}  \n ${uderData1['state']}\n${uderData1['country']}',
                                      style: pw.TextStyle(
                                        font: ttfFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            Colors.black.value),
                                      ),
                                    ),
                                  ]),
                              pw.SizedBox(height: 7),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'EMAIL',
                                      style: pw.TextStyle(
                                        font: normalFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            const Color.fromRGBO(76, 75, 75, 1)
                                                .value),
                                      ),
                                    ),
                                    pw.Text(
                                      '${uderData1['email']}',
                                      style: pw.TextStyle(
                                        font: ttfFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            Colors.black.value),
                                      ),
                                    ),
                                  ]),
                              pw.SizedBox(height: 7),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'PHONE',
                                      style: pw.TextStyle(
                                        font: normalFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            const Color.fromRGBO(76, 75, 75, 1)
                                                .value),
                                      ),
                                    ),
                                    pw.Text(
                                      '${uderData1['phone']}',
                                      style: pw.TextStyle(
                                        font: ttfFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            Colors.black.value),
                                      ),
                                    ),
                                  ]),
                              pw.SizedBox(height: 7),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'GST',
                                      style: pw.TextStyle(
                                        font: normalFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            const Color.fromRGBO(76, 75, 75, 1)
                                                .value),
                                      ),
                                    ),
                                    pw.Text(
                                      '${uderData1['gst']}',
                                      style: pw.TextStyle(
                                        font: ttfFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            Colors.black.value),
                                      ),
                                    ),
                                  ]),
                            ]),
                        pw.SizedBox(width: 27),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      '${data["billingTO"]["billingCompany"]}',
                                      style: pw.TextStyle(
                                        font: normalFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            const Color.fromRGBO(76, 75, 75, 1)
                                                .value),
                                      ),
                                    ),
                                    pw.Text(
                                      '${data["billingTO"]["addressline"]} \n ${data["billingTO"]["city"]} - ${data["billingTO"]["pin"]}  \n ${data["billingTO"]["state"]}\n${data["billingTO"]["country"]}',
                                      style: pw.TextStyle(
                                        font: ttfFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            Colors.black.value),
                                      ),
                                    ),
                                  ]),
                              pw.SizedBox(height: 7),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'EMAIL',
                                      style: pw.TextStyle(
                                        font: normalFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            const Color.fromRGBO(76, 75, 75, 1)
                                                .value),
                                      ),
                                    ),
                                    pw.Text(
                                      '${data["billingTO"]["email"]}',
                                      style: pw.TextStyle(
                                        font: ttfFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            Colors.black.value),
                                      ),
                                    ),
                                  ]),
                              pw.SizedBox(height: 7),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'PHONE',
                                      style: pw.TextStyle(
                                        font: normalFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            const Color.fromRGBO(76, 75, 75, 1)
                                                .value),
                                      ),
                                    ),
                                    pw.Text(
                                      '${data["billingTO"]["phone"]}',
                                      style: pw.TextStyle(
                                        font: ttfFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            Colors.black.value),
                                      ),
                                    ),
                                  ]),
                              pw.SizedBox(height: 7),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'GST',
                                      style: pw.TextStyle(
                                        font: normalFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            const Color.fromRGBO(76, 75, 75, 1)
                                                .value),
                                      ),
                                    ),
                                    pw.Text(
                                      'GSTIN 29GGGGG1314R9Z6',
                                      style: pw.TextStyle(
                                        font: ttfFont,
                                        fontSize: 10,
                                        color: PdfColor.fromInt(
                                            Colors.black.value),
                                      ),
                                    ),
                                  ]),
                            ])
                      ])
                    ]),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 30),
                  child: pw.Column(
                    children: [
                      pw.Divider(
                          thickness: 3, color: PdfColor.fromHex('#6D8970')),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 2, bottom: 2),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              flex: 1,
                              child: pw.Align(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                  'S.NO',
                                  style: pw.TextStyle(
                                    font: normalFont,
                                    fontSize: 15,
                                    color: PdfColor.fromInt(Colors.black.value),
                                  ), // Define your PdfFonts.secTittle style
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 3,
                              child: pw.Align(
                                alignment: pw.Alignment.centerLeft,
                                child: pw.Text(
                                  'Product name',
                                  style: pw.TextStyle(
                                    font: normalFont,
                                    fontSize: 15,
                                    color: PdfColor.fromInt(Colors.black.value),
                                  ), // Define your PdfFonts.secTittle style
                                  // overflow: pw.TextOverflow,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Align(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                  'Price',
                                  style: pw.TextStyle(
                                    font: normalFont,
                                    fontSize: 15,
                                    color: PdfColor.fromInt(Colors.black.value),
                                  ), // Define your PdfFonts.secTittle style
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Align(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                  'Qty',
                                  style: pw.TextStyle(
                                    font: normalFont,
                                    fontSize: 15,
                                    color: PdfColor.fromInt(Colors.black.value),
                                  ), // Define your PdfFonts.secTittle style
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Align(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                  'Total',
                                  style: pw.TextStyle(
                                    font: normalFont,
                                    fontSize: 15,
                                    color: PdfColor.fromInt(Colors.black.value),
                                  ), // Define your PdfFonts.secTittle style
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Divider(
                          thickness: 3, color: PdfColor.fromHex('#6D8970')),
                    ],
                  ),
                ),
                pw.ListView.separated(
                  separatorBuilder: (context, index) =>
                      pw.Divider(thickness: 1),
                  itemBuilder: (pw.Context context, int index) {
                    final lineItemId = data["lineItems"].keys.elementAt(index);
                    final lineItemData = data["lineItems"][lineItemId];
                    final itemName = lineItemData["itemName"];
                    final total = lineItemData["total"];
                    final itemQuantity = lineItemData["itemQuantity"];
                    final itemPrice = lineItemData["itemPrice"];
                    // final itemTax = lineItemData["itemTax"];
                    return pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            flex: 1,
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                ' ${index + 1}',
                                style: pw.TextStyle(
                                  font: normalFont,
                                  fontSize: 10,
                                  color: PdfColor.fromInt(
                                      const Color.fromRGBO(76, 75, 75, 1)
                                          .value),
                                ),
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 3,
                            child: pw.Align(
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text(
                                itemName,
                                // overflow: pw.TextOverflow.ellipsis,
                                style: pw.TextStyle(
                                  font: normalFont,
                                  fontSize: 10,
                                  color: PdfColor.fromInt(
                                      const Color.fromRGBO(76, 75, 75, 1)
                                          .value),
                                ), // Define your PdfFonts.secondaryFont style
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                itemPrice,
                                style: pw.TextStyle(
                                  font: normalFont,
                                  fontSize: 10,
                                  color: PdfColor.fromInt(
                                      const Color.fromRGBO(76, 75, 75, 1)
                                          .value),
                                ),
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                itemQuantity,
                                style: pw.TextStyle(
                                  font: normalFont,
                                  fontSize: 10,
                                  color: PdfColor.fromInt(
                                      const Color.fromRGBO(76, 75, 75, 1)
                                          .value),
                                ), // Define your PdfFonts.secondaryFont style
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                total,
                                style: pw.TextStyle(
                                  font: normalFont,
                                  fontSize: 10,
                                  color: PdfColor.fromInt(
                                      const Color.fromRGBO(76, 75, 75, 1)
                                          .value),
                                ), // Define your PdfFonts.secondaryFont style
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: data["lineItems"].length,
                ),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.SizedBox(
                    width: PdfPageFormat.a4.width / 2,
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'SUB TOTAL',
                              style: pw.TextStyle(
                                font: ttfFont,
                                fontSize: 10,
                                color: PdfColors.black,
                              ),
                            ),
                            pw.Text(
                              '\$${data["billingTO"]["sub_total"]}',
                              style: pw.TextStyle(
                                font: normalFont,
                                fontSize: 10,
                                color: PdfColor.fromInt(
                                    const Color.fromRGBO(76, 75, 75, 1).value),
                              ), // Define your PdfFonts.secondaryFont style
                            ),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'DISCOUNT',
                              style: pw.TextStyle(
                                font: ttfFont,
                                fontSize: 10,
                                color: PdfColors.black,
                              ),
                            ),
                            pw.Text(
                              '${data["billingTO"]["discount"]}%',
                              style: pw.TextStyle(
                                font: normalFont,
                                fontSize: 10,
                                color: PdfColor.fromInt(
                                    const Color.fromRGBO(76, 75, 75, 1).value),
                              ), // Define your PdfFonts.secondaryFont style
                            ),
                          ],
                        ),
                        pw.SizedBox(
                          width: double.infinity,
                          child: pw.Divider(
                              thickness: 3, color: PdfColor.fromHex('#6D8970')),
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'TOTAL',
                              style: pw.TextStyle(
                                font: ttfFont,
                                fontSize: 10,
                                color: PdfColors.black,
                              ), // Define your PdfFonts.ternaryFont style
                            ),
                            pw.Text(
                              '\$${data["billingTO"]["grand_total"]}',
                              style: pw.TextStyle(
                                font: normalFont,
                                fontSize: 10,
                                color: PdfColor.fromInt(
                                    const Color.fromRGBO(76, 75, 75, 1).value),
                              ), // Define your PdfFonts.ternaryFont style
                            ),
                          ],
                        ),
                        pw.Divider(
                            thickness: 3, color: PdfColor.fromHex('#6D8970'))
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(height: 40),
                pw.Align(
                  alignment: pw.Alignment.bottomCenter,
                  child: pw.Text(
                    'Thanks for your business',
                    style: pw.TextStyle(
                      font: ttfFont,
                      fontSize: 10,
                      color: PdfColors.black,
                    ), // Define your PdfFonts.secondaryFont style
                  ),
                ),
              ],
            )
          ];
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Directory? dir;
          final pdfBytes = await makePdf(); // Generate the PDF

          dir = await getExternalStorageDirectory();

          final file = File('${dir!.path}/invoice.pdf');
          await file.writeAsBytes(pdfBytes); // Save PDF to file

          // Show a message or perform any other action after saving
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PDF saved successfully')),
          );
        },
        child: const Icon(Icons.save),
      ),
      appBar: AppBar(
        title: const Text('Invoice PDF'),
      ),
      body: PdfPreview(
        pdfFileName: 'abc',
        canChangeOrientation: false,
        canDebug: false,
        build: (format) => makePdf(),
      ),
    );
  }
}
