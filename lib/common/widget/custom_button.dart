import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String lebel;
  final VoidCallback onTap;
  const CustomButton({super.key, required this.lebel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 55),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        child: Text(lebel),
      ),
    );
  }
}
