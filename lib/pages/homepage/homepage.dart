import 'package:ezbill/pages/contacts/contacts.dart';
import 'package:ezbill/pages/create_invoice/create_invoice.dart';
import 'package:ezbill/pages/homepage/home_page_components/sidebar.dart';
import 'package:ezbill/pages/line_items/line_items.dart';
import 'package:ezbill/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ezbill/styles/fonts.dart';
import 'package:ezbill/pages/pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: SpecialColors.appColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: SpecialColors.appColor,
      ),
      drawer: SideBar(email: FirebaseAuth.instance.currentUser!.email),
      body: SafeArea(
        child: Container(
          // decoration: const BoxDecoration(
          //   // borderRadius: BorderRadius.all(Radius.circular(50)),
          //   image: DecorationImage(
          //       image: AssetImage("assets/accpattern.jpg"), fit: BoxFit.cover.w),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(' '),
              // Container(
              //     height: MediaQuery.of(context).size.height / 4,
              //     decoration: const BoxDecoration(
              //       borderRadius: BorderRadius.all(Radius.circular(50)),
              //       image: DecorationImage(
              //           image: AssetImage("assets/accpattern.jpg"),
              //           fit: BoxFit.cover),
              //     )),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateInvoice()));
                          },
                          child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width / 2.5,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 3),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 70,
                                    child: Image.asset(
                                      "assets/bill.png",
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Create Invoice',
                                    style: TextFonts.labelText)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Contacts()));
                          },
                          child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width / 2.5,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 3),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 75,
                                    child: Image.asset(
                                      "assets/contacts.jpg",
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Create Contacts',
                                    style: TextFonts.labelText)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LineItems()));
                          },
                          child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width / 2.5,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 3),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 85,
                                    child: Image.asset(
                                      "assets/shop.jpg",
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('My Shop', style: TextFonts.labelText)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width / 2.5,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 3),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 80,
                                    child: Image.asset(
                                      "assets/statistics.jpg",
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Statistics', style: TextFonts.labelText)
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
