import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ezbill/common_widget/waiting_page.dart';
import 'package:ezbill/pages/homepage/homepage.dart';
import 'package:ezbill/pages/pages.dart';
import 'package:ezbill/styles/colors.dart';
import 'package:flutter/material.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _index = 0;
  List pagesList = [
    const HomePage(),
    const WaitingPage(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pagesList[_index],
      bottomNavigationBar: CurvedNavigationBar(
          index: _index,
          // color: SpecialColors.appColor,
          buttonBackgroundColor: SpecialColors.specialGreenColor,
          backgroundColor: SpecialColors.appColor,
          items: const <Widget>[
            Icon(Icons.home_filled, size: 30),
            Icon(Icons.settings, size: 30),
            Icon(Icons.person, size: 30),
          ],
          onTap: (index) {
            setState(() {
              _index = index;
            });
          }),
    );
  }
}
