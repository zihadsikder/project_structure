import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final Function(String)? onChanged;
  final String hintText;
  final double borderRadius;
  final Color borderColor;

  const CustomSearchField({
    super.key,
    this.onChanged,
    this.hintText = "Search",
    this.borderRadius = 33,
    this.borderColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
