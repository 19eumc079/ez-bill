import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.selectedValue,
    this.validator,
  }) : super(key: key);

  final List<String> items;
  final String? selectedValue;

  final Function(String?)? onChanged;
  final String? Function(String?)? validator;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2(
          validator: widget.validator,
          isExpanded: true,
          hint: const Text(
            '-- Select --',
            overflow: TextOverflow.ellipsis,
          ),
          items: widget.items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: widget.selectedValue,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.arrow_downward),
            openMenuIcon: Icon(Icons.arrow_upward),
            iconSize: 20,
            iconEnabledColor: Color.fromARGB(
              255,
              223,
              225,
              230,
            ),
          ),
          dropdownStyleData: const DropdownStyleData(
            offset: Offset(0, 0),
            maxHeight: 150,
            // width: screenWidth,
            elevation: 8,
            padding: null,
          ),
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 10, right: 10),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          )
          // overlayColor: MaterialStatePropertyAll(AppColor)),
          ),
    );
  }
}
