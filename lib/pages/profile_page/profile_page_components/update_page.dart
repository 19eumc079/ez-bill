import 'package:ezbill/common_widget/customTextField.dart';
import 'package:ezbill/common_widget/label.dart';
import 'package:ezbill/styles/fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:loading_overlay/loading_overlay.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage(
      {super.key,
      required this.city,
      required this.companyname,
      required this.country,
      required this.email,
      required this.landmark,
      required this.phone,
      required this.pin,
      required this.prefix,
      required this.state,
      required this.street});
  final String email;
  final String companyname;
  final String phone;
  final String landmark;
  final String street;
  final String? city;
  final String? state;
  final String pin;
  final String? country;
  final String prefix;

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final companyNameController = TextEditingController();
  final landmarkController = TextEditingController();
  final streetController = TextEditingController();
  final zipController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final prefixlabelController = TextEditingController();
  final phoneController = TextEditingController();
  String? cityValue;
  String? stateValue;
  String? countryValue;
  final focus = FocusNode();
  bool passwordsMatch = true;
  // final _registerFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData() {
    setState(() {
      companyNameController.text = widget.companyname;
      emailController.text = widget.email;
      phoneController.text = widget.phone;
      landmarkController.text = widget.landmark;
      streetController.text = widget.street;
      countryValue = widget.country;
      stateValue = widget.state;
      cityValue = widget.city;
      zipController.text = widget.pin;
      prefixlabelController.text = widget.prefix;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'update profile',
                style: TextFonts.secondaryText,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                    Text(
                      'Address',
                      style: TextFonts.ternaryText,
                    ),
                    // CustomTextField(
                    //     hintText: 'Door no / Land Mark',
                    //     controller: landmarkController,
                    //     maxlines: 1,
                    //     textType: TextInputType.text),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        hintText: 'Adddress Line',
                        controller: streetController,
                        maxlines: 1,
                        textType: TextInputType.text),
                    const SizedBox(
                      height: 10,
                    ),
                    CSCPicker(
                      disableCountry: true,
                      flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                      defaultCountry: CscCountry.India,
                      currentCity: cityValue,
                      currentCountry: countryValue,
                      currentState: stateValue,
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
                    CustomTextField(
                        hintText: 'Pin code',
                        controller: zipController,
                        maxlines: 1,
                        textType: TextInputType.number),
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
                      onChanged: (phone) {},
                    ),
                    CustomTextField(
                        suffixIcon: const Icon(Icons.lock),
                        enabled: false,
                        hintText: 'Email',
                        controller: emailController,
                        maxlines: 1,
                        textType: TextInputType.text),
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
                        child: FilledButton(
                            onPressed: () async {
                              // if (_registerFormKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                await FirebaseDatabase.instance
                                    .ref()
                                    .child('users')
                                    .child(
                                        FirebaseAuth.instance.currentUser!.uid)
                                    .child('user_details')
                                    .update({
                                  'company_name': companyNameController.text,
                                  'addressline': streetController.text,
                                  'country': countryValue,
                                  'state': stateValue,
                                  'city': cityValue,
                                  'pin': '636501',
                                  'phone': phoneController.text,
                                  'prefix_invoice': prefixlabelController.text
                                });
                                setState(() {
                                  isLoading = false; // Hide loading overlay
                                });
                                Navigator.pop(context);
                                const ScaffoldMessenger(
                                    child: SnackBar(
                                        content:
                                            Text('successfully updated ')));
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
