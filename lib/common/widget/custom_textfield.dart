import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const CustomTextfield(
      {super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w100,
                color: Colors.grey,
              ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
                // color: Theme.of(context).colorScheme.error, // not working
                ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return hintText;
          }
          return null;
        },
      ),
    );
  }
}
