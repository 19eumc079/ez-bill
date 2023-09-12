import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.maxlines,
      required this.textType,
      this.validate,
      this.onChanged,
      this.readOnly,
      this.onTap,
      this.enabled,
      this.hintText,
      this.suffixIcon})
      : super(key: key);

  final TextEditingController controller;
  final int maxlines;
  final TextInputType textType;
  final String? Function(String?)? validate;
  final void Function()? onTap;
  final bool? readOnly;
  final bool? enabled;
  final String? hintText;
  final Icon? suffixIcon;

  final void Function(String)? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextField();
}

class _CustomTextField extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      maxLines: widget.maxlines,
      readOnly: widget.readOnly ?? false,
      enabled: widget.enabled ?? true,
      decoration: InputDecoration(
        errorStyle: const TextStyle(height: 0),
        hintText: widget.hintText ?? '',
        suffixIcon: widget.suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        enabledBorder: const OutlineInputBorder(
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
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                width: 2,
                color: Color.fromARGB(
                  255,
                  223,
                  225,
                  230,
                ))),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
      keyboardType: widget.textType,
      validator: widget.validate,
      controller: widget.controller,
      cursorColor: Colors.black,
    );
  }
}
