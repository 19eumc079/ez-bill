import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final companyNameController = TextEditingController();
  final addresslineController = TextEditingController();

  final pinController = TextEditingController();
  final gstController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  String? cityValue;
  String? stateValue;
  String? countryValue;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(106, 132, 108, 1),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                CustomTextField(
                    controller: companyNameController,
                    textInputType: TextInputType.text,
                    hintText: "Company Name",
                    prefixIcon: Icon(Icons.branding_watermark_rounded)),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    controller: addresslineController,
                    textInputType: TextInputType.text,
                    hintText: "Address Line",
                    prefixIcon: Icon(Icons.map)),
                const SizedBox(
                  height: 20,
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
                // CustomTextField(
                //     controller: stateController,
                //     textInputType: TextInputType.text,
                //     hintText: "State",
                //     prefixIcon: Icon(Icons.location_on_sharp)),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    // Expanded(
                    //   child: CustomTextField(
                    //       controller: cityController,
                    //       textInputType: TextInputType.text,
                    //       hintText: "City",
                    //       prefixIcon: Icon(Icons.location_city)),
                    // ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: CustomTextField(
                          controller: pinController,
                          textInputType: TextInputType.number,
                          hintText: "Pin Code",
                          prefixIcon: Icon(Icons.pin)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    controller: gstController,
                    textInputType: TextInputType.text,
                    hintText: "Gst.No",
                    prefixIcon: Icon(Icons.numbers)),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    controller: phoneController,
                    textInputType: TextInputType.phone,
                    hintText: "Phone",
                    prefixIcon: Icon(Icons.phone_android)),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    controller: emailController,
                    textInputType: TextInputType.emailAddress,
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email_sharp)),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: FilledButton.icon(
                      icon: Icon(Icons.create_outlined),
                      style: FilledButton.styleFrom(
                          backgroundColor: Color.fromRGBO(106, 132, 108, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7))),
                      onPressed: () async {
                        var uuid = Uuid();
                        print(FirebaseAuth.instance.currentUser!.uid);
                        await FirebaseDatabase.instance
                            .ref()
                            .child(
                                'users/${FirebaseAuth.instance.currentUser!.uid}/contacts')
                            .push()
                            .set({
                          'id': uuid.v1(),
                          'company_name': companyNameController.text,
                          'address_line': addresslineController.text,
                          'state': stateValue,
                          'city': cityValue,
                          'country': countryValue,
                          'pin': pinController.text,
                          'gst': gstController.text,
                          'phone': phoneController.text,
                          'email': emailController.text
                        }).then((value) => Navigator.pop(context));
                      },
                      label: const Text('Create Customer')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      required this.hintText,
      required this.prefixIcon,
      required this.textInputType,
      required this.controller})
      : super(key: key);
  final String hintText;
  final Widget prefixIcon;
  final TextInputType textInputType;
  final TextEditingController controller;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              color: Color.fromRGBO(187, 187, 187, 1),
              width: 2,
            ),
          ),
          prefixIcon: widget.prefixIcon,
          labelText: widget.hintText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
                color: Color.fromRGBO(106, 132, 108, 1), width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.grey),
              borderRadius: BorderRadius.circular(7)),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            ),
          )),
    );
  }
}
