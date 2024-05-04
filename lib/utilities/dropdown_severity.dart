import 'package:flutter/material.dart';

const List<String> list = <String>[
  'very_minimum',
  'low',
  'high',
  'very_high',
];

class SeverityOption extends StatefulWidget {
  final void Function(String selectedValue) onChanged;

  const SeverityOption({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<SeverityOption> createState() => _SeverityOptionState();
}

class _SeverityOptionState extends State<SeverityOption> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<String>(
        value: dropdownValue,
        // Replace the icon with a different icon widget
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 14,),
        style: const TextStyle(color: Colors.black),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          if (value != null) {
            setState(() {
              dropdownValue = value;
            });
            widget.onChanged(dropdownValue); // Trigger the callback
          }
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        // Replace underline with a Container having box shadow from all directions
        underline: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffEBEBEB),
              width: 1.0,
            ),
          ),
        ),
        autofocus: true,
        dropdownColor: Colors.white, // Set dropdown background color
        elevation: 8, // Set elevation to give a shadow effect
        borderRadius: BorderRadius.circular(8), // Set border radius for dropdown
        itemHeight: 48, // Set item height for each dropdown item
        iconSize: 24, // Set icon size
        isExpanded: true, // Allow the dropdown to expand
      ),
    );
  }
}