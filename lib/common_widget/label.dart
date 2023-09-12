import 'package:flutter/material.dart';

import '../styles/fonts.dart';

class ValidationLabel extends StatelessWidget {
  const ValidationLabel({Key? key, required this.label}) : super(key: key);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextFonts.ternaryText,
        ),
        const Text(
          '*',
          style: TextStyle(color: Colors.red, fontSize: 15),
        )
      ],
    );
  }
}
