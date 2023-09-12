import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, required this.email});
  final String? email;
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.email!.split('@')[0]),
            accountEmail: Text(widget.email ?? 'Something issue'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                  child: Image.asset(
                'assets/836.jpg',
                fit: BoxFit.cover,
                height: 90,
                width: 901,
              )),
            ),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/pinknav.jpg'),
                    fit: BoxFit.cover)),
          ),
          InkWell(
            onTap: () => FirebaseAuth.instance.signOut(),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text("Log Out"),
            ),
          )
        ],
      ),
    );
  }
}
