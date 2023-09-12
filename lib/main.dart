import 'package:ezbill/pages/bottom_navigation.dart';

import 'package:ezbill/common_widget/waiting_page.dart';
import 'package:ezbill/pages/login_page/login_page.dart';
import 'package:ezbill/provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'styles/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvoiceProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: SpecialColors.appColor),
          useMaterial3: true,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const WaitingPage();
            } else if (snapshot.hasData) {
              return const BottomNavigationPage();
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
