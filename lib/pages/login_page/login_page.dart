import 'package:ezbill/pages/new_user/new_user.dart';
import 'package:ezbill/styles/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../common_widget/auth_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final focus = FocusNode();
  Future resetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(12, 28, 44, 1),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                  child: Text(
                    'Sign-in to your \nAccount',
                    style: TextFonts.primaryText,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Form(
                      key: loginFormKey,
                      child: AutofillGroup(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 35,
                            ),
                            EmailTextFieldWidget(
                              companyIdController: emailController,
                              validate: (value) {
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!);
                                if (value.trim().isEmpty ||
                                    emailValid == false) {
                                  return "Enter the correct email address";
                                }
                                return null;
                              },
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).requestFocus(focus);
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            PasswordTextFieldWidget(
                              focus: focus,
                              passwordController: passwordController,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter the correct password";
                                }
                                return null;
                              },
                              onFieldSubmitted: (val) {},
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: const BeveledRectangleBorder(),
                                      elevation: 5,
                                      backgroundColor: const Color.fromRGBO(
                                          192, 232, 99, 1)),
                                  onPressed: () async {
                                    if (loginFormKey.currentState!.validate()) {
                                      try {
                                        await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );
                                        // User creation successful, you can navigate to the next screen here
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => HomePage()),
                                        // );
                                      } catch (e) {
                                        // Handle error and show a Snackbar
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            dismissDirection:
                                                DismissDirection.startToEnd,
                                            showCloseIcon: true,
                                            shape: ContinuousRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            content:
                                                Text("Error: ${e.toString()}"),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextFonts.secondaryText,
                                  )),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            emailController.text.isNotEmpty
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () => resetPassword(
                                          email: emailController.text),
                                      child: Text('forgot password'),
                                    ),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewUser()));
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    'Don\'t have an account? ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'Register ',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 111, 100, 16)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
