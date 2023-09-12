import 'package:flutter/material.dart';

import '../styles/colors.dart';

class EmailTextFieldWidget extends StatefulWidget {
  const EmailTextFieldWidget({
    Key? key,
    required this.companyIdController,
    required this.validate,
    required this.onFieldSubmitted,
  }) : super(key: key);
  final Function(String)? onFieldSubmitted;
  final TextEditingController companyIdController;

  final FormFieldValidator<String> validate;

  @override
  State<EmailTextFieldWidget> createState() => _EmailTextFieldWidgetState();
}

class _EmailTextFieldWidgetState extends State<EmailTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: const [AutofillHints.email],
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        hintText: 'Email Address',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: SpecialColors.secondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: SpecialColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        prefixIcon: IconTheme(
          data: IconThemeData(color: IconColors.primaryColor),
          child: Icon(Icons.people_alt_outlined),
        ),
      ),
      validator: widget.validate,
      controller: widget.companyIdController..text,
      cursorColor: Colors.black,
    );
  }
}

class PasswordTextFieldWidget extends StatefulWidget {
  const PasswordTextFieldWidget(
      {Key? key,
      required this.passwordController,
      required this.validate,
      required this.onFieldSubmitted,
      required this.focus,
      this.hintText})
      : super(key: key);
  final Function(String)? onFieldSubmitted;
  final TextEditingController passwordController;
  final String? hintText;
  final FocusNode focus;
  final FormFieldValidator<String> validate;

  @override
  State<PasswordTextFieldWidget> createState() =>
      _PasswordTextFieldWidgetState();
}

class _PasswordTextFieldWidgetState extends State<PasswordTextFieldWidget> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscure,
      autofillHints: const [AutofillHints.password],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        hintText: widget.hintText ?? 'Password',
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: SpecialColors.secondaryColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: SpecialColors.primaryColor),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        prefixIcon: IconTheme(
          data: const IconThemeData(color: IconColors.primaryColor),
          child: IconButton(
            icon: _isObscure
                ? const Icon(Icons.visibility_off_outlined)
                : const Icon(Icons.visibility_outlined),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
        ),
      ),
      validator: widget.validate,
      controller: widget.passwordController..text,
      cursorColor: Colors.black,
    );
  }
}
