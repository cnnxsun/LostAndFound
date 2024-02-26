import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String? hint;
  final InputBorder? inputBorder;
  const CustomInput({super.key, this.onChanged, this.hint, this.inputBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: TextField(
          minLines: 1, // Set the minimum number of lines
          maxLines: 5, // Set the maximum number of lines

          onChanged: (String v) => onChanged?.call(v),
          decoration: InputDecoration(hintText: hint!, border: inputBorder),
        ),
      ),
    );
  }
}
