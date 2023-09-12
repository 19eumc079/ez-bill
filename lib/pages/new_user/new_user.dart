import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../common_widget/auth_field.dart';
import '../../common_widget/customTextField.dart';
import '../../common_widget/label.dart';
import '../../styles/colors.dart';
import '../../styles/fonts.dart';

import 'package:loading_overlay/loading_overlay.dart';

class NewUser extends StatefulWidget {
  const NewUser({super.key});

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final companyNameController = TextEditingController();
  final landmarkController = TextEditingController();
  final streetController = TextEditingController();
  final zipController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final gstNumController = TextEditingController();
  final prefixlabelController = TextEditingController();
  final phoneController = TextEditingController();
  String? cityValue;
  String? stateValue;
  String? countryValue;
  final focus = FocusNode();
  bool passwordsMatch = true;
  final _registerFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  static String? gstvalidate(String? value) {
    if (value == null || value.isEmpty) {
      return "GST number is required";
    }

    RegExp gstPattern = RegExp(
      r'^[0-9A-Za-z]{2}[0-9A-Za-z]{10}[0-9A-Za-z]{1}[0-9A-Za-z]{1}$',
    );

    if (!gstPattern.hasMatch(value)) {
      return "Invalid GST number format";
    }

    // Additional checks such as checksum validation could be performed here

    return null; // GST number is valid
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: LoadingOverlay(
        isLoading: isLoading,
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          // backgroundColor: const Color.fromRGBO(12, 28, 44, 1),
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(12, 28, 44, 1),
            toolbarHeight: MediaQuery.of(context).size.height / 6,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_sharp,
                  color: Colors.white,
                )),
            title: ListTile(
              title: Text(
                'Register',
                style: TextFonts.primaryText,
              ),
              subtitle: const Text(
                'Create your account',
                style: TextStyle(color: Colors.white),
              ),
            ),
            titleSpacing: 5,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _registerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ValidationLabel(label: 'Company Name'),
                    CustomTextField(
                      hintText: 'Enter valid company name',
                      controller: companyNameController,
                      maxlines: 1,
                      textType: TextInputType.text,
                      validate: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return '';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const ValidationLabel(label: 'GST'),
                    CustomTextField(
                      hintText: 'Please enter valid Gst Number',
                      controller: gstNumController,
                      maxlines: 1,
                      textType: TextInputType.text,
                      validate: gstvalidate,
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // Text(
                    //   'Address',
                    //   style: TextFonts.ternaryText,
                    // ),
                    // CustomTextField(
                    //     hintText: 'Door no / Land Mark',
                    //     controller: landmarkController,
                    //     maxlines: 1,
                    //     textType: TextInputType.text),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        hintText: 'Address Line',
                        controller: streetController,
                        maxlines: 1,
                        textType: TextInputType.text),
                    const SizedBox(
                      height: 10,
                    ),
                    CSCPicker(
                      disableCountry: true,
                      defaultCountry: CscCountry.India,
                      onCountryChanged: (value) {
                        setState(() {
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
                      height: 20,
                    ),
                    const ValidationLabel(label: 'Contact Details'),
                    IntlPhoneField(
                      controller: phoneController,
                      validator: (val) {
                        if (val == null || val == '') {
                          return '';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 5),
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
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                    ),
                    EmailTextFieldWidget(
                      companyIdController: emailController,
                      validate: (value) {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!);
                        if (value.trim().isEmpty || emailValid == false) {
                          return "Enter the correct email address";
                        }
                        return null;
                      },
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(focus);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const ValidationLabel(label: 'Security'),
                    PasswordTextFieldWidget(
                      focus: focus,
                      passwordController: passwordController,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter the correct password";
                        } else if (value != passwordController.text) {
                          passwordsMatch = false;
                          return "Passwords do not match";
                        }
                        passwordsMatch = true;
                        return null;
                      },
                      onFieldSubmitted: (val) {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PasswordTextFieldWidget(
                      hintText: 'Confirm Password',
                      focus: focus,
                      passwordController: confirmPasswordController,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter the correct password";
                        } else if (value != passwordController.text) {
                          passwordsMatch = false;
                          return "Passwords do not match";
                        }
                        passwordsMatch = true;
                        return null;
                      },
                      onFieldSubmitted: (val) {},
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Prefix Invoice Text',
                      style: TextFonts.ternaryText,
                    ),
                    TextField(
                      controller: prefixlabelController,
                      maxLength: 6,
                      onChanged: (value) {
                        prefixlabelController.value = TextEditingValue(
                            text: value.toUpperCase(),
                            selection: prefixlabelController.selection);
                      },
                      decoration: const InputDecoration(
                          hintText: 'EX - LCI',
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: SpecialColors.appColor),
                            onPressed: () async {
                              // if (_registerFormKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );

                                final DatabaseReference userRef =
                                    FirebaseDatabase.instance
                                        .ref()
                                        .child('users')
                                        .child(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .child('user_details');

                                await userRef.set({
                                  'company_name': companyNameController.text,
                                  'gst': gstNumController.text,
                                  'addressline': streetController.text,
                                  'country': countryValue,
                                  'state': stateValue,
                                  'city': cityValue,
                                  'pin': '636501',
                                  'phone': phoneController.text,
                                  'email': emailController.text,
                                  'prefix_invoice': prefixlabelController.text
                                }).then((value) {
                                  const ScaffoldMessenger(
                                      child: SnackBar(
                                          content:
                                              Text('Registered successfully')));
                                  Navigator.pop(context);
                                });
                                setState(() {
                                  isLoading = false; // Hide loading overlay
                                });
                              } catch (e) {
                                setState(() {
                                  isLoading = false; // Hide loading overlay
                                });
                                // Handle error and show a Snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    dismissDirection:
                                        DismissDirection.startToEnd,
                                    showCloseIcon: true,
                                    shape: ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    content: Text("Error: ${e.toString()}"),
                                  ),
                                );
                              }
                              // }
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(color: Colors.white),
                            )))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
