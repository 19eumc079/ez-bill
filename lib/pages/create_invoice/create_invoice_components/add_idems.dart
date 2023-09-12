import 'package:ezbill/common_widget/common_widget.dart';
import 'package:ezbill/provider/provider.dart';
import 'package:ezbill/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../styles/colors.dart';

class AddItems extends StatefulWidget {
  const AddItems({super.key});

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  //TextEditingController discountController = TextEditingController();
  TextEditingController taxRateController = TextEditingController();
  //String? discount;
  String total = 0.toString();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      itemPriceController.text = 0.toString();
      itemQuantityController.text = 0.toString();
      // discount = 'Percentage';
      // discountController.text = 0.toString();
      taxRateController.text = 0.toString();
      // total = 0.toString();
    });
  }

  calculation() {
    setState(() {
      num itemPrice = num.parse(itemPriceController.text);
      num itemQuantity = num.parse(itemQuantityController.text);
      num item = itemPrice * itemQuantity;
      // num discountAmount = 0;
      // if (discount == 'Percentage') {
      //   num discountPercentage = num.parse(discountController.text);
      //   discountAmount = (item * discountPercentage / 100);
      //   // item -= discountAmount;
      // } else {
      //   num discountAmount = num.parse(discountController.text);
      //   // item -= discountAmount;
      // }

      num taxRate = num.parse(taxRateController.text);
      num taxAmount = item * taxRate / 100;
      item += taxAmount;

      total = item.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Item',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: SpecialColors.appColor,
        ),
        backgroundColor: SpecialColors.specialblueColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Item Name",
                                style: TextFonts.ternaryText,
                              ),
                              CustomTextField(
                                  controller: itemNameController,
                                  maxlines: 1,
                                  textType: TextInputType.text),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Item Price",
                                style: TextFonts.ternaryText,
                              ),
                              CustomTextField(
                                  onChanged: (val) => calculation(),
                                  controller: itemPriceController,
                                  maxlines: 1,
                                  textType: TextInputType.number),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Item Quantity",
                                style: TextFonts.ternaryText,
                              ),
                              CustomTextField(
                                  onChanged: (val) => calculation(),
                                  controller: itemQuantityController,
                                  maxlines: 1,
                                  textType: TextInputType.number),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Text(
                              //   "Discount",
                              //   style: TextFonts.ternaryText,
                              // ),
                              // Row(
                              //   children: [
                              //     Flexible(
                              //       child: CustomDropDown(
                              //           items: ['Percentage', 'Fixed'],
                              //           onChanged: (val) {
                              //             setState(() {
                              //               val = discount;
                              //               calculation();
                              //             });
                              //           },
                              //           selectedValue: discount),
                              //     ),
                              //     const SizedBox(
                              //       width: 15,
                              //     ),
                              //     Flexible(
                              //       child: CustomTextField(
                              //           onChanged: (val) => calculation(),
                              //           hintText: " 0\%",
                              //           controller: discountController,
                              //           maxlines: 1,
                              //           textType: TextInputType.number),
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Tax",
                                style: TextFonts.ternaryText,
                              ),
                              CustomTextField(
                                  onChanged: (val) => calculation(),
                                  hintText: " 0\%",
                                  controller: taxRateController,
                                  maxlines: 1,
                                  textType: TextInputType.number),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: SpecialColors.appColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total:',
                                    style: TextFonts.normalwhiteText),
                                Text(
                                  total,
                                  style: TextFonts.normalwhiteText,
                                ),
                              ]),
                        ),
                      )
                    ],
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: SpecialColors.specialGreenColor),
                  onPressed: () {
                    Provider.of<InvoiceProvider>(context, listen: false)
                        .addItem({
                      'itemName': itemNameController.text,
                      'itemPrice': itemPriceController.text,
                      'itemQuantity': itemQuantityController.text,
                      'itemTax': taxRateController.text,
                      'total': total
                    });

                    Navigator.pop(context);
                  },
                  child: Text(
                    "Add Item",
                    style: TextFonts.secondaryText,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
